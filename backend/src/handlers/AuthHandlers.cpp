#include "handlers/AuthHandlers.h"
#include "domain/auth/Token.h"
#include "models/User.h"
#include <iostream>
//не забыть добавить проверку корректности почты

net::awaitable<Response> AuthHandler::registerUser(Request req) {

    std::cout << req.body() << std::endl;
    auto json = nlohmann::json::parse(req.body());
    std::string email = json["email"];
    auto token = Token<32>::generate();
    auto hash = TokenHash32::hash(token);
    co_await auth_.insertMagicLinkToken(hash.to_pqxx(),"email",email);
    co_await auth_.sendAuthLinkToEmail(email,token.to_string());
    // co_await auth_.createUser(token,"email",email);
    Response res{http::status::ok, req.version()};
    res.body() = "Email sent";

    res.prepare_payload();

    co_return res;
}

net::awaitable<Response> AuthHandler::verifyUser(Request req) {
    Response res{http::status::ok, req.version()};
    res.body() = "Email sent";
    co_return res;
}

AuthHandler::AuthHandler(AuthService &authService) : auth_(authService) {
}
