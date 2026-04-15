#include "../../include/http/Session.h"

#include <iostream>

Session::Session(tcp::socket socket,std::shared_ptr<Router> router)
: stream_(std::move(socket)), router_(router)
{
}

void Session::run()
{
    http::async_read(
        stream_,
        buffer_,
        req_,
        beast::bind_front_handler(
            &Session::on_read,
            shared_from_this()));
}

void Session::on_read(beast::error_code ec, std::size_t)
{
    if (ec)
        return;

    std::string path = std::string(req_.target());

    auto req = std::move(req_);
    auto handler = router_->get(path);

    auto self = shared_from_this();

    net::co_spawn(
        stream_.get_executor(),
        [self, handler, req = std::move(req)]() mutable -> net::awaitable<void>
        {
            auto res = co_await handler(std::move(req));

            res.prepare_payload();

            co_await http::async_write(
                self->stream_,
                res,
                net::use_awaitable
            );

            beast::error_code ec;
            self->stream_.socket().shutdown(tcp::socket::shutdown_send, ec);
        },
        net::detached
    );
}