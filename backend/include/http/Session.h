#pragma once
#include "utils/alias.h"
#include "Router.h"

using handler_t = std::function<void(
    const http::request<http::string_body>&,
    http::response<http::string_body>&)>;

class Session : public std::enable_shared_from_this<Session>
{
    beast::tcp_stream stream_;
    beast::flat_buffer buffer_;
    http::request<http::string_body> req_;

    std::shared_ptr<Router> router_;

public:
    explicit Session(tcp::socket socket, std::shared_ptr<Router> router);

    void run();
    void on_read(beast::error_code ec, std::size_t);
};