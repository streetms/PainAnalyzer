//
// Created by konstantin on 07.05.2026.
//

#ifndef PAINAPP_AUTHREPOSITORY_H
#define PAINAPP_AUTHREPOSITORY_H
#include "database/ConnectionPool.h"
#include "database/Database.h"
#include "utils/alias.h"
class AuthRepository {
private:
    db::Database& db_;
    public:
    AuthRepository(db::Database& db) : db_(db) {}

    net::awaitable<void> saveAuthToken(std::string_view hash, std::string_view type_id, std::string_view id);
};


#endif //PAINAPP_AUTHREPOSITORY_H
