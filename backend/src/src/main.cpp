#include <iostream>
#include <stacktrace>
#include <cpphttp/router.hpp>
#include <cpphttp/server.hpp>
#include <cpphttp/server_config.hpp>
#include "app/AppContext.h"
#include "infrastructure/http/routes/RegisterRoutes.h"
#include "utils/load_dotenv.h"
void my_terminate_handler()
{
    std::cerr << "Unhandled exception!\n";
    std::cerr << std::stacktrace::current() << std::endl;
    std::_Exit(1);
}
void router_setup(cpphttp::Router& router, AppContext& ctx) {
    routes::registerAuthRoutes(router,ctx.authHandler);
    routes::registerPainEpisodeRoutes(router,ctx.painEpisodeHandler);
}

int main()
{
    try {
        load_dotenv();

        net::io_context ioc;

        auto ctx = std::make_shared<AppContext>(ioc, 10, 4);

        cpphttp::Router router;
        router_setup(router, *ctx);

        cpphttp::ServerConfig server_config;
        server_config.address = "0.0.0.0";
        server_config.port = 5555;
        cpphttp::Server server(ioc.get_executor(), std::move(router), server_config);
        server.start();

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