//
// Created by konstantin on 11.04.2026.
//

#include "../../include/http/Server.h"
#include "../../include/http/Session.h"
Server::Server(net::io_context &ioc, tcp::endpoint endpoint,std::shared_ptr<Router> router)
        : acceptor_(ioc), socket_(ioc),router_(router)
{
    acceptor_.open(endpoint.protocol());
    acceptor_.set_option(net::socket_base::reuse_address(true));
    acceptor_.bind(endpoint);
    acceptor_.listen();
}
void Server::run() {
    accept();
}
void Server::accept() {
            acceptor_.async_accept(
                socket_,
                beast::bind_front_handler(
                        &Server::on_accept,
                        shared_from_this()));
}
void Server::on_accept(beast::error_code ec){
    if (!ec) {
        std::make_shared<Session>(std::move(socket_),router_)->run();
    }
    accept();
}