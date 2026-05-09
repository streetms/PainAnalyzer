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

    net::io_context ioc;

    auto ctx = std::make_shared<AppContext>(ioc, 10, 4);

    auto router = std::make_shared<Router>();
    router_setup(*router, *ctx);

    std::make_shared<Server>(
        ioc,
        tcp::endpoint(tcp::v4(), 5555),
        router
    )->run();

    std::cout << "Server started on port 5555\n";
    std::vector<std::thread> threads;
    int n = std::thread::hardware_concurrency();
    for (int i = 0; i < n; ++i) {
        threads.emplace_back([&ioc]() {
            ioc.run();
        });
    }

    for (auto& t : threads) t.join();
}