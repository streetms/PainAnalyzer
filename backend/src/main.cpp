#include <iostream>
#include <stacktrace>
#include "../include/modules/auth/AuthService.h"
#include "infrastructure/http/Router.h"
#include "infrastructure/http/Server.h"
#include "app/AppContext.h"
#include "infrastructure/http/routes/RegisterRoutes.h"
#include "utils/load_dotenv.h"
void my_terminate_handler()
{
    std::cerr << "Unhandled exception!\n";
    std::cerr << std::stacktrace::current() << std::endl;
    std::_Exit(1);
}
void router_setup(Router& router, AppContext& ctx) {
    routes::registerAuthRoutes(router,ctx.authHandler);
}

int main()
{
    try {
        load_dotenv();

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
                while (true) {
                    try {
                        ioc.run();
                    } catch (std::exception& e) {
                        std::cerr << e.what() << std::endl;
                        ioc.run();
                    }
                }
            });
        }

        for (auto& t : threads) {
            t.join();
        }
    }
        catch (std::exception& e) {
            std::cerr << e.what() << std::endl;
        }
}