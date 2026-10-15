#include <iostream>
#include <cpphttp/server.hpp>

#include "../include/cpphttp/session.hpp"

#include <boost/asio/dispatch.hpp>
#include <boost/beast/core.hpp>

#include <utility>

namespace cpphttp {
namespace asio = boost::asio;
namespace beast = boost::beast;
using tcp = asio::ip::tcp;

class Server::Impl final : public std::enable_shared_from_this<Server::Impl> {
public:
    Impl(asio::any_io_executor executor, Router router, ServerConfig config)
        : executor_(std::move(executor)), acceptor_(executor_), socket_(executor_),
          router_(std::make_shared<const Router>(std::move(router))),
          config_(std::move(config)) {
        const auto address = asio::ip::make_address(config_.address);
        const tcp::endpoint endpoint(address, config_.port);

        acceptor_.open(endpoint.protocol());
        acceptor_.set_option(asio::socket_base::reuse_address(true));
        acceptor_.bind(endpoint);
        acceptor_.listen(asio::socket_base::max_listen_connections);
    }


    void start() {
        accept();
    }

    void stop() {
        auto self = shared_from_this();
        asio::dispatch(executor_, [self] {
            self->stopping_ = true;
            boost::system::error_code ignored;
            self->acceptor_.close(ignored);
            self->socket_.close(ignored);
        });
    }

private:
    void accept() {
        std::cerr << "accept() called\n";

        if (stopping_ || !acceptor_.is_open()) {
            std::cerr << "stopping_ = " << std::boolalpha << stopping_
                      << ", acceptor_.is_open() = "
                      << acceptor_.is_open() << '\n';
            return;
        }
        auto self = shared_from_this();
        acceptor_.async_accept(socket_, [self](boost::system::error_code ec) {
            if (!ec) {
                std::make_shared<detail::Session>(
                    beast::tcp_stream(std::move(self->socket_)), self->router_)->start();
                self->socket_ = tcp::socket(self->executor_);
            }
            if (ec != asio::error::operation_aborted && !self->stopping_) self->accept();
        });
    }

    asio::any_io_executor executor_;
    tcp::acceptor acceptor_;
    tcp::socket socket_;
    std::shared_ptr<const Router> router_;
    ServerConfig config_;
    bool stopping_ = false;
};

Server::Server(asio::any_io_executor executor, Router router, ServerConfig config)
    : impl_(std::make_shared<Impl>(std::move(executor), std::move(router), std::move(config))) {}

Server::~Server() {
    if (impl_) impl_->stop();
}

Server::Server(Server&& other) noexcept = default;

Server& Server::operator=(Server&& other) noexcept {
    if (this != &other) {
        if (impl_) impl_->stop();
        impl_ = std::move(other.impl_);
    }
    return *this;
}

void Server::start() {
    impl_->start();
}

void Server::stop() {
    if (impl_) impl_->stop();
}

}
