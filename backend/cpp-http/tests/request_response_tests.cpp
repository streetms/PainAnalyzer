#define BOOST_TEST_MODULE cpphttp_request_response_tests
#include <boost/test/included/unit_test.hpp>

#include <cpphttp/method.hpp>
#include <cpphttp/request.hpp>
#include <cpphttp/response.hpp>

#include <stdexcept>
#include <string>

using namespace cpphttp;

BOOST_AUTO_TEST_CASE(request_stores_method_target_path_and_body)
{
    Request request(Method::post, "/attacks/42?details=true", {}, "{\"intensity\":7}");

    BOOST_CHECK(request.method() == Method::post);
    BOOST_CHECK(request.target() == "/attacks/42?details=true");
    BOOST_CHECK(request.path() == "/attacks/42");
    BOOST_CHECK(request.body() == "{\"intensity\":7}");
}

BOOST_AUTO_TEST_CASE(request_without_query_preserves_full_target_as_path)
{
    Request request(Method::get, "/health");
    BOOST_CHECK(request.target() == "/health");
    BOOST_CHECK(request.path() == "/health");
}

BOOST_AUTO_TEST_CASE(request_header_lookup_is_case_insensitive)
{
    Request request(Method::post, "/", {
        {"Content-Type", "application/json"},
        {"X-Request-ID", "abc-123"}
    });

    const auto content_type = request.header("content-type");
    BOOST_REQUIRE(content_type.has_value());
    BOOST_CHECK(*content_type == "application/json");

    const auto request_id = request.header("X-REQUEST-id");
    BOOST_REQUIRE(request_id.has_value());
    BOOST_CHECK(*request_id == "abc-123");
    BOOST_CHECK(!request.header("Authorization").has_value());
    BOOST_CHECK_EQUAL(request.headers().size(), 2U);
}

BOOST_AUTO_TEST_CASE(response_default_and_text_factory)
{
    Response default_response;
    BOOST_CHECK_EQUAL(default_response.status(), 200U);
    BOOST_CHECK(default_response.body().empty());

    auto response = Response::text("OK");
    BOOST_CHECK_EQUAL(response.status(), 200U);
    BOOST_CHECK(response.body() == "OK");

    const Response::Header* content_type = nullptr;
    for (const auto& header : response.headers()) {
        if (header.first == "Content-Type") {
            content_type = &header;
            break;
        }
    }
    BOOST_REQUIRE(content_type != nullptr);
    BOOST_CHECK(content_type->second == "text/plain; charset=utf-8");
}

BOOST_AUTO_TEST_CASE(response_empty_and_mutators)
{
    auto response = Response::empty();
    BOOST_CHECK_EQUAL(response.status(), 204U);

    response.status(201).body("created").header("X-Trace", "first");
    BOOST_CHECK_EQUAL(response.status(), 201U);
    BOOST_CHECK(response.body() == "created");
    BOOST_REQUIRE_EQUAL(response.headers().size(), 1U);
    BOOST_CHECK(response.headers().front().first == "X-Trace");
    BOOST_CHECK(response.headers().front().second == "first");
}

BOOST_AUTO_TEST_CASE(response_header_replacement_is_case_insensitive)
{
    auto response = Response::text("body");
    response.header("X-Trace", "first");
    response.header("x-trace", "second");

    std::size_t trace_count = 0;
    for (const auto& [name, value] : response.headers()) {
        if (name == "x-trace" || name == "X-Trace") {
            ++trace_count;
            BOOST_CHECK(value == "second");
        }
    }
    BOOST_CHECK_EQUAL(trace_count, 1U);
}

BOOST_AUTO_TEST_CASE(response_rejects_invalid_status_codes)
{
    BOOST_CHECK_THROW(Response response(99), std::invalid_argument);
    BOOST_CHECK_THROW(Response response(600), std::invalid_argument);

    Response response;
    BOOST_CHECK_THROW(response.status(99), std::invalid_argument);
    BOOST_CHECK_THROW(response.status(600), std::invalid_argument);
}
