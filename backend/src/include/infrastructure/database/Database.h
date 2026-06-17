#pragma once
#include "infrastructure/database/ConnectionPool.h"
#include "utils/alias.h"
#include <type_traits>

namespace db {
    class Database {
    public:
        Database(net::thread_pool& pool, ConnectionPool& conn_pool)
            : pool_(pool), conn_pool_(conn_pool) {}

        template<typename Func>
        auto run(Func fn) -> net::awaitable<std::invoke_result_t<Func, pqxx::work&>>
        {
            // std::invoke_result_t — более чистая альтернатива decltype(std::declval...)
            using Result = std::invoke_result_t<Func, pqxx::work&>;
            co_return co_await net::co_spawn(
                pool_,
                [this, fn = std::move(fn)]() -> net::awaitable<Result> {
                    auto conn = conn_pool_.acquire();
                    pqxx::work tx(*conn);

                    if constexpr (std::is_void_v<Result>) {
                        fn(tx);
                        tx.commit();
                        co_return;
                    } else {
                        auto res = fn(tx);
                        tx.commit();
                        co_return res;
                    }
            },
                net::use_awaitable // <-- Главный секрет избавления от future
            );
        }

    private:
        net::thread_pool& pool_;
        ConnectionPool& conn_pool_;
    };
}