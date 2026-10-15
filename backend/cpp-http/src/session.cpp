#include <cpphttp/session.hpp>

#include <iostream>
#include <boost/asio/co_spawn.hpp>
#include <boost/asio/detached.hpp>
#include <boost/asio/use_awaitable.hpp>
#include <boost/beast/http.hpp>

#include <string>
#include <utility>
#include <vector>

namespace cpphttp::detail {
namespace asio = boost::asio;
namespace beast = boost::beast;
namespace http = beast::http;
using tcp = asio::ip::tcp;

namespace {

std::optional<Method> to_method(http::verb verb) {
    switch (verb) {
        case http::verb::get: return Method::get;
        case http::verb::head: return Method::head;
        case http::verb::post: return Method::post;
        case http::verb::put: return Method::put;
        case http::verb::patch: return Method::patch;
        case http::verb::delete_: return Method::delete_;
        case http::verb::options: return Method::options;
        default: return std::nullopt;
    }
}

http::response<http::string_body> make_wire_response(const Response& source, unsigned version) {
    http::response<http::string_body> response{
        static_cast<http::status>(source.status()), version
    };
    for (const auto& [name, value] : source.headers()) response.set(name, value);
    response.body() = source.body();
    response.prepare_payload();
    return response;
}

}

Session::Session(beast::tcp_stream stream, std::shared_ptr<const Router> router)
    : stream_(std::move(stream)), router_(std::move(router)) {
    std::cout << "start session" << std::endl;
}

void Session::start() {
    http::async_read(stream_, buffer_, beast_request_,
        beast::bind_front_handler(&Session::on_read, shared_from_this()));
}


void Session::on_read(boost::system::error_code ec, std::size_t) {
    if (ec) return;

    const auto method = to_method(beast_request_.method());
    if (!method) return;

    std::vector<Request::Header> headers;
    for (const auto& field : beast_request_.base()) {
        headers.emplace_back(std::string(field.name_string()), std::string(field.value()));
    }

    const auto version = beast_request_.version();
    Request request(*method, std::string(beast_request_.target()),
                    std::move(headers), std::move(beast_request_.body()));
    auto handler = router_->get(request.path());
    if (!handler) return;

    auto self = shared_from_this();
    asio::co_spawn(stream_.get_executor(),
        [self, handler = std::move(handler), request = std::move(request), version]() mutable
            -> asio::awaitable<void> {
            auto response = co_await handler(std::move(request));
            auto wire_response = make_wire_response(response, version);
            co_await http::async_write(self->stream_, wire_response, asio::use_awaitable);
            boost::system::error_code ignored;
            self->stream_.socket().shutdown(tcp::socket::shutdown_send, ignored);
        }, asio::detached);
}

}
