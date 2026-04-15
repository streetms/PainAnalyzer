#include "handlers/AuthHandlers.h"

net::awaitable<Response> registerUser(Request req, AppContext& ctx){
    auto json = nlohmann::json::parse(req.body());
    auto email = json["email"];

    co_await ctx.auth->sendAuthLinkToEmail(email);

    Response res{http::status::ok, req.version()};
    res.body() = "Email sent";
    res.prepare_payload();

    co_return res;
}