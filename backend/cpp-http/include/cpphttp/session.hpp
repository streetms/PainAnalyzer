#pragma once

#include <cpphttp/router.hpp>

#include <boost/beast/core.hpp>
#include <boost/beast/http.hpp>

#include <memory>
namespace cpphttp::detail {

class Session final : public std::enable_shared_from_this<Session> {
public:
    Session(boost::beast::tcp_stream stream, std::shared_ptr<const Router> router);
    void start();

private:
    void on_read(boost::system::error_code ec, std::size_t bytes_transferred);

    boost::beast::tcp_stream stream_;
    boost::beast::flat_buffer buffer_;
    boost::beast::http::request<boost::beast::http::string_body> beast_request_;
    std::shared_ptr<const Router> router_;
};

}
