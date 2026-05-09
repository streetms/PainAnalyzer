#include <iostream>
#include <dotenv.h>
#include "service/AuthService.h"
#include "http/Router.h"
#include "http/Server.h"
#include "app/AppContext.h"
#include "http/routes/RegisterRoutes.h"

void router_setup(Router& router, AppContext& ctx) {
    routes::registerAuthRoutes(router,ctx.authHandler);
}

int main()
{
    dotenv::env.load_dotenv();
    auto ctx = std::make_shared<AppContext>(10,4);
    auto router = std::make_shared<Router>();
    router_setup(*router, *ctx);
    net::io_context ioc;

    std::make_shared<Server>(
            ioc,
            tcp::endpoint(tcp::v4(), 5555),router)->run();

    std::cout << "Server started on port 5555\n";

    ioc.run();
}