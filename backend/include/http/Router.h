#pragma once
#include <functional>
#include <string>
#include <unordered_map>
#include "utils/alias.h"


class Router {
public:
    using handler_t  = std::function<
    net::awaitable<Response>(Request)>;

    void add(const std::string& path, handler_t handler);

    handler_t get(const std::string& path);
private:
    std::unordered_map<std::string, handler_t> routes_;
};
