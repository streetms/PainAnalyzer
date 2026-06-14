#include "modules/auth/AuthHandlers.h"
#include "infrastructure/domain/Token.h"

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

net::awaitable<Response> AuthHandler::verifyMagicLink(Request req) {
    std::cout << "verify" << std::endl;
    http::response<http::empty_body> res{http::status::found, req.version()};
    try {
        // 1️⃣ Получаем token из query
        std::string target = std::string(req.target());
        auto pos = target.find("token=");

        // if (pos == std::string::npos) {
        //     co_await sendBadRequest(stream, "Token missing");
        //     co_return;
        // }

        std::string token = target.substr(pos + 6);

        // если есть другие query параметры — обрежем
        auto amp = token.find('&');
        if (amp != std::string::npos)
            token = token.substr(0, amp);

        // // 2️⃣ Проверка токена (твоя логика)
        // auto userId = co_await authService.verifyMagicToken(token);
        //
        // if (!userId.has_value()) {
        //     co_await sendUnauthorized(stream, "Invalid or expired token");
        //     co_return;
        // }

        // // 3️⃣ Помечаем токен использованным
        // co_await authService.markTokenUsed(token);

        // 4️⃣ Делаем redirect в приложение
        std::string redirectUrl = std::format(
            "patient://auth/patient/verify?token={}",
            token
        );


        res.set(http::field::location, redirectUrl);
        res.set(http::field::server, "PainAnalyzer");
        res.prepare_payload();
    }
    catch (const std::exception& e) {
        std::cerr << "Magic link error: " << e.what() << std::endl;
    }
    co_return res;
}

AuthHandler::AuthHandler(AuthService &authService) : auth_(authService) {
}
