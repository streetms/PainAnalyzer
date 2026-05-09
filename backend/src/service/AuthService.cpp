

#include <nlohmann/json.hpp>

#include <boost/asio/awaitable.hpp>
#include <boost/asio/use_awaitable.hpp>
#include <boost/asio/ssl.hpp>
#include <boost/beast/core.hpp>
#include <boost/beast/http.hpp>
#include <boost/beast/ssl.hpp>

#include <iostream>
#include <format>

#include "domain/auth/Token.h"
#include "utils/alias.h"
#include "service/AuthService.h"


namespace ssl = boost::asio::ssl;

AuthService::AuthService(AuthRepository &authRepository) : authRepository_(authRepository) {
}

std::string AuthService::getTokenFromTarget(const std::string &target) {
    auto pos = target.find("token=");
    if (pos == std::string::npos)
        return "";

    return target.substr(pos + 6);
}

net::awaitable<void> AuthService::sendAuthLinkToEmail(std::string_view email,std::string_view token) {
        auto executor = co_await net::this_coro::executor;
    ssl::context ctx(ssl::context::tlsv12_client);
    ctx.set_default_verify_paths();
    ctx.set_verify_mode(ssl::verify_peer);

    beast::ssl_stream<beast::tcp_stream> stream(executor, ctx);

    SSL_set_tlsext_host_name(stream.native_handle(), "api.resend.com");

    tcp::resolver resolver(executor);
    auto results = co_await resolver.async_resolve("api.resend.com", "443", net::use_awaitable);

    co_await beast::get_lowest_layer(stream).async_connect(results, net::use_awaitable);
    co_await stream.async_handshake(ssl::stream_base::client, net::use_awaitable);
    std::string link = std::format(
            "http://streetms.ru:5555/auth/verify?token={}",
            token
    );

    nlohmann::json json{
            {"from", "PainAnalyzer <onboarding@resend.dev>"},
            {"to", nlohmann::json::array({email})},
            {"subject", "Авторизация PainAnalyzer"},
            {"html",std::format("Перейдите по {}, чтобы войти в свою учетную запись\n"
                                 "Срок действия этой ссылки истечет через 10 минут.\n"
                                 "\n"
                                 "Если вы не запрашивали это электронное письмо, вы можете проигнорировать его.",
                                 to_html_link("ссылке",link))}
    };

    http::request<http::string_body> req{http::verb::post, "/emails", 11};
    req.set(http::field::host, "api.resend.com");
    req.set(http::field::content_type, "application/json");
    req.set(http::field::user_agent, "PainAnalyzer");
    auto API_KEY = std::string(std::getenv("RESEND_API_KEY"));
    req.set("Authorization", "Bearer "+ API_KEY);

    req.body() = json.dump();
    req.prepare_payload();
    try {
        co_await http::async_write(stream, req, net::use_awaitable);

        beast::flat_buffer buffer;
        http::response<http::string_body> res;

        co_await http::async_read(stream, buffer, res, net::use_awaitable);

        std::cout << "Status: " << res.result_int() << "\n";
        std::cout << "Response: " << res.body() << "\n";
    }
    catch (const std::exception& e) {
        std::cerr << "Exception: " << e.what() << std::endl;
    }
    co_return;
}

net::awaitable<void> AuthService::saveAuthToken(std::string_view hash, std::string_view type_id, std::string_view id) {
    co_await authRepository_.saveAuthToken(hash, type_id, id);
}

std::string AuthService::to_html_link(std::string_view text, std::string_view link) {
    return std::format("<a href='{}'>{}</a>",link,text);
}


