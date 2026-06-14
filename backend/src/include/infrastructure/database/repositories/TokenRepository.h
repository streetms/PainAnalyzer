//
// Created by konstantin on 26.05.2026.
//

#ifndef PAINAPP_TOKENREPOSITORY_H
#define PAINAPP_TOKENREPOSITORY_H
#include "infrastructure/database/Database.h"

class TokenRepository {

public:
    int64_t insertToken(pqxx::work& tx,pqxx::bytes token_hash, uint64_t ttl_seconds);
    void insertMagicLink(pqxx::work& tx,int64_t token_id, int64_t identity_id, std::string_view token_type);

    struct Statements {
        static constexpr std::string_view InsertToken = "insert_token";
        static constexpr std::string_view InsertMagicLink = "Insert_magic_link";
    };
    static void prepare(pqxx::connection* conn);
};


#endif //PAINAPP_TOKENREPOSITORY_H
