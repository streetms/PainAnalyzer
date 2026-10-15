#pragma once

#include <cpphttp/router.hpp>
#include <cpphttp/server_config.hpp>

#include <boost/asio/any_io_executor.hpp>

#include <memory>

namespace cpphttp {

class Server {
public:
    Server(
        boost::asio::any_io_executor executor,
        Router router,
        ServerConfig config = {}
    );

    ~Server();

    Server(Server&&) noexcept;
    Server& operator=(Server&&) noexcept;

    Server(const Server&) = delete;
    Server& operator=(const Server&) = delete;

    void start();
    void stop();

private:
    class Impl;
    std::shared_ptr<Impl> impl_;
};

} // namespace cpphttp
