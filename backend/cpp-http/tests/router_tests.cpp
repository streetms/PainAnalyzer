#define BOOST_TEST_MODULE cpphttp_router_tests
#include <boost/test/included/unit_test.hpp>

#include <cpphttp/request.hpp>
#include <cpphttp/response.hpp>
#include <cpphttp/router.hpp>

#include <boost/asio/co_spawn.hpp>
#include <boost/asio/io_context.hpp>
#include <boost/asio/use_future.hpp>

namespace asio = boost::asio;
using namespace cpphttp;

BOOST_AUTO_TEST_CASE(exact_path_lookup)
{
    Router router;
    router.add("/users/42",
        [](Request) -> asio::awaitable<Response> {
            co_return Response::text("user");
        });

    BOOST_CHECK(static_cast<bool>(router.get("/users/42")));
    BOOST_CHECK(!router.get("/users/43"));
}

BOOST_AUTO_TEST_CASE(same_path_overwrites_previous_handler)
{
    Router router;
    router.add("/health", [](Request) -> asio::awaitable<Response> {
        co_return Response::text("old");
    });
    router.add("/health", [](Request) -> asio::awaitable<Response> {
        co_return Response::text("new");
    });

    auto handler = router.get("/health");
    BOOST_REQUIRE(static_cast<bool>(handler));

    asio::io_context io;
    auto future = asio::co_spawn(io, handler(Request(Method::get, "/health")), asio::use_future);
    io.run();
    BOOST_CHECK_EQUAL(future.get().body(), "new");
}

BOOST_AUTO_TEST_CASE(request_path_excludes_query)
{
    Request request(Method::get, "/users/42?verbose=true");
    BOOST_CHECK(request.path() == "/users/42");
    BOOST_CHECK(request.target() == "/users/42?verbose=true");
}
