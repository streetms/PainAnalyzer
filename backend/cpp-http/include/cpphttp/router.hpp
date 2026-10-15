#pragma once

#include <cpphttp/handler.hpp>

#include <string>
#include <string_view>
#include <unordered_map>

namespace cpphttp {

class Router {
public:
    using handler_t = Handler;

    void add(const std::string& path, handler_t handler);
    handler_t get(std::string_view path) const;

private:
    std::unordered_map<std::string, handler_t> routes_;
};

}
