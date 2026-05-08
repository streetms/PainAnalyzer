#pragma once
#include <functional>
#include <string>
#include <unordered_map>
#include "utils/alias.h"
#include "app/AppContext.h"

class Router {
public:
    using handler_t  = std::function<
    net::awaitable<Response>(Request,AppContext&)>;
    using boundHandler_t = std::function<
    net::awaitable<Response>(Request)>;
    Router(std::shared_ptr<AppContext> ctx)
           : ctx_(ctx) {}
    void add(const std::string& path, handler_t handler);

    boundHandler_t get(const std::string& path);
private:
    std::unordered_map<std::string, handler_t> routes_;
    std::shared_ptr<AppContext> ctx_;
};
