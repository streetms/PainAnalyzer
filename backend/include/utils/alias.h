#pragma once

#include <boost/beast.hpp>
#include <boost/asio.hpp>
#include <nlohmann/json.hpp>

namespace beast = boost::beast;
namespace http  = beast::http;
namespace net   = boost::asio;
using tcp  = net::ip::tcp;
using json = nlohmann::json;
using Request  = http::request<http::string_body>;
using Response = http::response<http::string_body>;