#pragma once
#include "database/ConnectionPool.h"
#include "utils/alias.h"
namespace db {
    class Database {
    public:
        Database(net::thread_pool& pool, ConnectionPool& conn_pool)
            : pool_(pool), conn_pool_(conn_pool) {}

        template<typename Func>
        auto run(Func fn)
            -> net::awaitable<decltype(fn(std::declval<pqxx::connection&>()))>
        {
            using Result = decltype(fn(std::declval<pqxx::connection&>()));

            auto fut = net::co_spawn(
                pool_,
                [this, fn = std::move(fn)]() -> net::awaitable<Result> {
                    auto conn = conn_pool_.acquire();

                    if constexpr (std::is_void_v<Result>) {
                        fn(*conn);
                        co_return;
                    } else {
                        co_return fn(*conn);
                    }
                },
                net::use_future
            );

            if constexpr (std::is_void_v<Result>) {
                co_await net::post(
                    net::use_awaitable
                );

                fut.get();
                co_return;
            } else {
                co_return fut.get();
            }
        }

    private:
        net::thread_pool& pool_;
        ConnectionPool& conn_pool_;
    };
}