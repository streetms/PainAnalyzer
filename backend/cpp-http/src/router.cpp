#include <cpphttp/router.hpp>

#include <utility>

namespace cpphttp {

void Router::add(const std::string& path, handler_t handler) {
    routes_[path] = std::move(handler);
}

Router::handler_t Router::get(std::string_view path) const {
    const auto it = routes_.find(std::string(path));
    if (it == routes_.end()) {
        return nullptr;
    }
    return it->second;
}

}
