//
// Created by konstantin on 07.05.2026.
//

#include "database/repositories/AuthRepository.h"

#include <iostream>

#include "database/queries/auth/create_auth_token.h"
#include "database/ConnectionPool.h"
net::awaitable<void> AuthRepository::saveAuthToken(std::string_view hash, std::string_view type_id,
                                     std::string_view id) {
    co_await  db_.run([&](pqxx::connection& conn) {
        pqxx::work work(conn);
        work.exec_prepared("create_user_identities",type_id,id);
        work.exec_prepared("create_auth_token", hash, type_id, id);
        work.commit();
        std::cout << "exec" << std::endl;
    });
    co_return;
}
