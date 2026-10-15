#include <cpphttp/request.hpp>

#include <algorithm>
#include <cctype>

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

Request::Request(Method method, std::string target,
                 std::vector<Header> headers, std::string body)
    : method_(method),
      target_(std::move(target)),
      path_(target_.substr(0, target_.find('?'))),
      body_(std::move(body)),
      headers_(std::move(headers)) {}

Method Request::method() const noexcept { return method_; }
std::string_view Request::target() const noexcept { return target_; }
std::string_view Request::path() const noexcept { return path_; }
std::string_view Request::body() const noexcept { return body_; }

const std::vector<Request::Header>& Request::headers() const noexcept {
    return headers_;
}

std::optional<std::string_view>
Request::header(std::string_view name) const noexcept {
    for (const auto& [key, value] : headers_) {
        if (iequals(key, name)) return value;
    }
    return std::nullopt;
}

}
