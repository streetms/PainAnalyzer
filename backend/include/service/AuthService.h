#pragma once

#include <boost/asio.hpp>
#include <string>
#include "database/repositories/IdentityRepository.h"
#include "database/repositories/TokenRepository.h"
#include "database/Database.h"
namespace net = boost::asio;

class AuthService
{
    db::Database& db_;
public:
    AuthService(db::Database& db) : db_(db) {}

    std::string getTokenFromTarget(const std::string& target);

    net::awaitable<void> insertMagicLinkToken(pqxx::bytes token_hash, std::string_view identity_type,std::string_view identifier);
    net::awaitable<void> sendAuthLinkToEmail(std::string_view email,std::string_view token);
    net::awaitable<void> createUser(std::string_view hash, std::string_view type_id, std::string_view id);
private:
    std::string to_html_link(std::string_view text, std::string_view link);
    IdentityRepository identityRepository_;
    TokenRepository tokenRepository_;
};