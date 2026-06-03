#pragma once
#include "infrastructure/database/ConnectionPool.h"
#include "utils/alias.h"
namespace db {
    class Database {
    public:
        Database(net::thread_pool& pool, ConnectionPool& conn_pool)
            : pool_(pool), conn_pool_(conn_pool) {}

        template<typename Func>
        auto run(Func fn)
            -> net::awaitable<decltype(fn(std::declval<pqxx::work&>()))>
        {
            using Result = decltype(fn(std::declval<pqxx::work&>()));

            auto fut = net::co_spawn(
                pool_,
                [this, fn = std::move(fn)]() -> net::awaitable<Result> {
                    auto conn = conn_pool_.acquire();
                    pqxx::work tx(*conn);
                    if constexpr (std::is_void_v<Result>) {
                        fn(tx);
                        co_return;
                    } else {
                        auto res = fn(tx);
                        tx.commit();
                        co_return res;
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