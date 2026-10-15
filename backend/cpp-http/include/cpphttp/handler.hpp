#pragma once

#include <cpphttp/request.hpp>
#include <cpphttp/response.hpp>

#include <boost/asio/awaitable.hpp>

#include <functional>

namespace cpphttp {

using Handler =
    std::function<boost::asio::awaitable<Response>(Request)>;

}