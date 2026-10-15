#include <cpphttp/response.hpp>

#include <algorithm>
#include <cctype>
#include <stdexcept>

namespace cpphttp {

namespace {

bool iequals(std::string_view a, std::string_view b) {
    if (a.size() != b.size()) return false;
    for (std::size_t i = 0; i < a.size(); ++i) {
        const auto ca = static_cast<unsigned char>(a[i]);
        const auto cb = static_cast<unsigned char>(b[i]);
        if (std::tolower(ca) != std::tolower(cb)) return false;
    }
    return true;
}

}

Response::Response(unsigned status) : status_(status) {
    if (status < 100 || status > 599) {
        throw std::invalid_argument("HTTP status must be in range 100..599");
    }
}

Response Response::text(std::string body) {
    Response response(200);
    response.header("Content-Type", "text/plain; charset=utf-8");
    response.body(std::move(body));
    return response;
}

Response Response::empty(unsigned status) {
    return Response(status);
}

unsigned Response::status() const noexcept { return status_; }

Response& Response::status(unsigned code) {
    if (code < 100 || code > 599) {
        throw std::invalid_argument("HTTP status must be in range 100..599");
    }
    status_ = code;
    return *this;
}

Response& Response::header(std::string name, std::string value) {
    for (auto& [existing_name, existing_value] : headers_) {
        if (iequals(existing_name, name)) {
            existing_name = std::move(name);
            existing_value = std::move(value);
            return *this;
        }
    }
    headers_.emplace_back(std::move(name), std::move(value));
    return *this;
}

Response& Response::body(std::string value) {
    body_ = std::move(value);
    return *this;
}



const std::string& Response::body() const noexcept { return body_; }

const std::vector<Response::Header>& Response::headers() const noexcept {
    return headers_;
}

}
