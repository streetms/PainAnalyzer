#pragma once

#include "utils/alias.h"
#include <cpphttp/handler.hpp>
#include <cpphttp/method.hpp>
#include <boost/beast/http.hpp>
#include <string>
#include <utility>
#include <vector>

namespace http_adapter {

inline cpphttp::Method to_cpphttp_method(http::verb method) {
    switch (method) {
        case http::verb::get: return cpphttp::Method::get;
        case http::verb::head: return cpphttp::Method::head;
        case http::verb::post: return cpphttp::Method::post;
        case http::verb::put: return cpphttp::Method::put;
        case http::verb::patch: return cpphttp::Method::patch;
        case http::verb::delete_: return cpphttp::Method::delete_;
        case http::verb::options: return cpphttp::Method::options;
        default: return cpphttp::Method::get;
    }
}

inline Request to_beast_request(cpphttp::Request request) {
    Request result;
    switch (request.method()) {
        case cpphttp::Method::get: result.method(http::verb::get); break;
        case cpphttp::Method::head: result.method(http::verb::head); break;
        case cpphttp::Method::post: result.method(http::verb::post); break;
        case cpphttp::Method::put: result.method(http::verb::put); break;
        case cpphttp::Method::patch: result.method(http::verb::patch); break;
        case cpphttp::Method::delete_: result.method(http::verb::delete_); break;
        case cpphttp::Method::options: result.method(http::verb::options); break;
    }
    result.target(request.target());
    result.version(11);
    for (const auto& [name, value] : request.headers()) {
        result.set(name, value);
    }
    result.body() = std::string(request.body());
    return result;
}

inline cpphttp::Response to_cpphttp_response(const Response& response) {
    cpphttp::Response result(static_cast<unsigned>(response.result_int()));
    for (const auto& field : response.base()) {
        result.header(std::string(field.name_string()), std::string(field.value()));
    }
    result.body(response.body());
    return result;
}

inline net::awaitable<cpphttp::Response> invoke_beast_handler(
    std::function<net::awaitable<Response>(Request)> handler,
    cpphttp::Request request) {
    auto beast_request = to_beast_request(std::move(request));
    auto beast_response = co_await handler(std::move(beast_request));
    co_return to_cpphttp_response(beast_response);
}

inline cpphttp::Handler adapt(
    std::function<net::awaitable<Response>(Request)> handler) {
    return [handler = std::move(handler)](cpphttp::Request request) mutable {
        return invoke_beast_handler(handler, std::move(request));
    };
}

} // namespace http_adapter
