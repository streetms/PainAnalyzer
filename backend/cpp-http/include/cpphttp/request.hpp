#pragma once

#include <cpphttp/method.hpp>

#include <optional>
#include <string>
#include <string_view>
#include <utility>
#include <vector>

namespace cpphttp {

class Router;

class Request {
public:
    using Header = std::pair<std::string, std::string>;

    Request() = default;
    Request(
        Method method,
        std::string target,
        std::vector<Header> headers = {},
        std::string body = {}
    );

    Method method() const noexcept;
    std::string_view target() const noexcept;
    std::string_view path() const noexcept;
    std::string_view body() const noexcept;

    std::optional<std::string_view>
    header(std::string_view name) const noexcept;

    const std::vector<Header>& headers() const noexcept;

private:
    Method method_ = Method::get;
    std::string target_;
    std::string path_;
    std::string body_;
    std::vector<Header> headers_;
};

}
