#include <infrastructure/http/Session.h>

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

    // 1. Получаем полный target как string_view (без лишних копирований)
    beast::string_view target = req_.target();
    std::string path;

    // 2. Ищем знак вопроса, чтобы отделить параметры
    auto pos = target.find('?');
    if (pos != beast::string_view::npos) {
        // Если есть '?', берем только ту часть, что ДО него
        path = std::string(target.substr(0, pos));
    } else {
        // Если '?' нет (например, это POST), берем целиком
        path = std::string(target);
    }

    // Теперь path гарантированно равен "/episodes"
    auto req = std::move(req_);

    // Роутер найдет обработчик по чистому пути
    auto handler = router_->get(path);

    if (!handler) {
        // Не забудьте обработать случай, если маршрут не найден (404 Not Found)
        std::cout << "Route not found: " << path << std::endl;
        return;
    }

    auto self = shared_from_this();
    std::cout << "Matched route: " << path << " (Full target: " << target << ")" << std::endl;
    
    net::co_spawn(
        stream_.get_executor(),
        [self, handler, req = std::move(req)]() mutable -> net::awaitable<void>
        {
            // Обработчик получит ВЕСЬ объект req, включая параметры!
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