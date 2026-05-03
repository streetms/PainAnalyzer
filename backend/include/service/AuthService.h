#pragma once

#include <boost/asio.hpp>
#include <string>

namespace net = boost::asio;

class AuthService
{
public:
    AuthService() = default;


    std::string getTokenFromTarget(const std::string& target);

    net::awaitable<void> sendAuthLinkToEmail(const std::string& email);

private:
    std::string makeAuthLink(const std::string& token);
    std::string to_html_link(std::string_view text, std::string_view link);
};