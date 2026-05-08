#include <iostream>
#include <dotenv.h>
#include "service/AuthService.h"
#include "http/Router.h"
#include "http/Server.h"
#include "app/AppContext.h"
#include "handlers/AuthHandlers.h"
void init_router(std::shared_ptr<Router> router) {
    router->add("/register",registerUser);

}

int main()
{
    dotenv::env.load_dotenv();
    auto ctx = std::make_shared<AppContext>();

    ctx->auth = std::make_shared<AuthService>();

    auto router = std::make_shared<Router>(ctx);
    init_router(router);
    net::io_context ioc;

    std::make_shared<Server>(
            ioc,
            tcp::endpoint(tcp::v4(), 5555),router)->run();

    std::cout << "Server started on port 5555\n";

    ioc.run();
}