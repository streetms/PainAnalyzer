//
// Created by konstantin on 15.04.2026.
//

#include "../../include/http/Router.h"

void Router::add(const std::string &path, handler_t handler) {
    routes_[path] = std::move(handler);
}

Router::handler_t Router::get(const std::string &path)
{
    auto it = routes_.find(path);

    if (it == routes_.end())
        return nullptr;

    return it->second;
}
