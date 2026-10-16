#define BOOST_TEST_MODULE cpphttp_server_integration_tests
#include <boost/test/included/unit_test.hpp>

#include <cpphttp/server.hpp>
#include <cpphttp/response.hpp>

#include <boost/asio.hpp>
#include <boost/beast/core.hpp>
#include <boost/beast/http.hpp>

#include <string>
#include <thread>

namespace asio = boost::asio;
namespace beast = boost::beast;
namespace http = beast::http;
using tcp = asio::ip::tcp;

namespace {

unsigned short unused_local_port()
{
    asio::io_context io;
    tcp::acceptor acceptor(io, {asio::ip::make_address("127.0.0.1"), 0});
    return acceptor.local_endpoint().port();
}

}

BOOST_AUTO_TEST_CASE(request_routing_and_response_over_real_connection)
{
    asio::io_context server_io;

    cpphttp::Router router;
    router.add("/health",
        [](cpphttp::Request request) -> asio::awaitable<cpphttp::Response> {
            const auto client_header = request.header("x-client-tag");
            const std::string tag = client_header ? std::string(*client_header) : "missing";
            auto response = cpphttp::Response::text(
                std::string(request.body()) + ":" + tag);
            response.status(201).header("X-Server-Tag", "cpp-http-test");
            co_return response;
        });

    const auto port = unused_local_port();
    cpphttp::Server server(server_io.get_executor(), std::move(router),
        {.address = "127.0.0.1", .port = port});
    server.start();
    std::thread server_thread([&] { server_io.run(); });

    try {
        asio::io_context client_io;
        tcp::socket socket(client_io);
        socket.connect({asio::ip::make_address("127.0.0.1"), port});

        // Legacy routing matches the path, regardless of HTTP method.
        http::request<http::string_body> request{http::verb::put,
            "/health?verbose=true", 11};
        request.set(http::field::host, "localhost");
        request.set("X-Client-Tag", "integration");
        request.set(http::field::content_type, "text/plain");
        request.body() = "payload";
        request.prepare_payload();
        request.keep_alive(true);
        http::write(socket, request);

        beast::flat_buffer buffer;
        http::response<http::string_body> response;
        http::read(socket, buffer, response);

        BOOST_CHECK(response.result() == http::status::created);
        BOOST_CHECK(response.body() == "payload:integration");
        BOOST_CHECK(response[http::field::content_type] == "text/plain; charset=utf-8");
        BOOST_CHECK(response["X-Server-Tag"] == "cpp-http-test");

        // Legacy behavior handles one request per TCP connection.
        boost::system::error_code ec;
        http::response<http::string_body> second_response;
        http::read(socket, buffer, second_response, ec);
        BOOST_CHECK(ec == http::error::end_of_stream || ec == asio::error::eof);

        server.stop();
        server_io.stop();
        server_thread.join();
    } catch (...) {
        server.stop();
        server_io.stop();
        if (server_thread.joinable()) server_thread.join();
        throw;
    }
}

BOOST_AUTO_TEST_CASE(unknown_route_closes_without_http_response)
{
    asio::io_context server_io;
    cpphttp::Router router;
    router.add("/known", [](cpphttp::Request) -> asio::awaitable<cpphttp::Response> {
        co_return cpphttp::Response::text("known");
    });

    const auto port = unused_local_port();
    cpphttp::Server server(server_io.get_executor(), std::move(router),
        {.address = "127.0.0.1", .port = port});
    server.start();
    std::thread server_thread([&] { server_io.run(); });

    try {
        asio::io_context client_io;
        tcp::socket socket(client_io);
        socket.connect({asio::ip::make_address("127.0.0.1"), port});

        http::request<http::string_body> request{http::verb::get, "/missing", 11};
        request.set(http::field::host, "localhost");
        request.keep_alive(false);
        http::write(socket, request);

        beast::flat_buffer buffer;
        http::response<http::string_body> response;
        boost::system::error_code ec;
        http::read(socket, buffer, response, ec);
        BOOST_CHECK(ec == http::error::end_of_stream || ec == asio::error::eof);

        server.stop();
        server_io.stop();
        server_thread.join();
    } catch (...) {
        server.stop();
        server_io.stop();
        if (server_thread.joinable()) server_thread.join();
        throw;
    }
}
