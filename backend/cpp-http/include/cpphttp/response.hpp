#pragma once

#include <string>
#include <utility>
#include <vector>

namespace cpphttp {

class Response {
public:
    using Header = std::pair<std::string, std::string>;

    explicit Response(unsigned status = 200);

    static Response text(std::string body);
    static Response empty(unsigned status = 204);

    unsigned status() const noexcept;
    Response& status(unsigned code);
    Response& header(std::string name, std::string value);
    Response& body(std::string value);
    const std::string& body() const noexcept;
    const std::vector<Header>& headers() const noexcept;

private:
    unsigned status_;
    std::vector<Header> headers_;
    std::string body_;
};

} // namespace cpphttp
