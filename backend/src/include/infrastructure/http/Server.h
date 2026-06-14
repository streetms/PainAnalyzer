#pragma once
#include "utils/alias.h"
#include "Router.h"
class Server : public std::enable_shared_from_this<Server>
{
    tcp::acceptor acceptor_;
    tcp::socket socket_;
    std::shared_ptr<Router> router_;
public:
    Server(net::io_context& ioc, tcp::endpoint endpoint,std::shared_ptr<Router> router);

    void run();

private:
    void accept();
    void on_accept(beast::error_code ec);
};