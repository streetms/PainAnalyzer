#pragma once

#include <boost/asio.hpp>
#include <string>
#include "database/repositories/AuthRepository.h"
namespace net = boost::asio;

class AuthService
{
public:
    AuthService(AuthRepository& authRepository);
    std::string getTokenFromTarget(const std::string& target);
    net::awaitable<void> sendAuthLinkToEmail(std::string_view email,std::string_view token);
    net::awaitable<void> saveAuthToken(std::string_view hash, std::string_view type_id, std::string_view id);
private:
    std::string to_html_link(std::string_view text, std::string_view link);
    AuthRepository& authRepository_;
};