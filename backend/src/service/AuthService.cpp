

#include <nlohmann/json.hpp>

#include <boost/asio/awaitable.hpp>
#include <boost/asio/use_awaitable.hpp>
#include <boost/asio/ssl.hpp>
#include <boost/beast/core.hpp>
#include <boost/beast/http.hpp>
#include <boost/beast/ssl.hpp>

#include <iostream>
#include <random>
#include <format>

#include "utils/alias.h"
#include "service/AuthService.h"
namespace ssl = boost::asio::ssl;


std::string AuthService::generateToken() {
    std::random_device rd;
    std::mt19937_64 gen(rd());
    std::uniform_int_distribution<uint64_t> dist;

    std::stringstream ss;
    ss << std::hex << dist(gen) << dist(gen);
    return ss.str();
}

std::string AuthService::getTokenFromTarget(const std::string &target) {
    auto pos = target.find("token=");
    if (pos == std::string::npos)
        return "";

    return target.substr(pos + 6);
}

net::awaitable<void> AuthService::sendAuthLinkToEmail(const std::string &email) {
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
            generateToken()
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
    req.set("Authorization", "Bearer re_LFx2HX9f_9fbsJbyAUpNQdPag12F9p6xu");

    req.body() = json.dump();
    req.prepare_payload();

    co_await http::async_write(stream, req, net::use_awaitable);

    beast::flat_buffer buffer;
    http::response<http::string_body> res;

    co_await http::async_read(stream, buffer, res, net::use_awaitable);

    std::cout << res.body() << std::endl;

    beast::error_code ec;
    stream.shutdown(ec);
}

std::string AuthService::to_html_link(std::string_view text, std::string_view link) {
    return std::format("<a href='{}'>{}</a>",link,text);
}

