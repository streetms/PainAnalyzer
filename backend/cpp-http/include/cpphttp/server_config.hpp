#pragma once

#include <cstdint>
#include <string>

namespace cpphttp {

struct ServerConfig {
    std::string address = "127.0.0.1";
    std::uint16_t port = 8080;
};

}
