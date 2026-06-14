//
// Created by konstantin on 26.05.2026.
//

#include "infrastructure/database/repositories/TokenRepository.h"


namespace {
    constexpr auto INSERT_TOKEN = R"SQL(
        insert into tokens (token_hash,expires_at)
            VALUES ($1,NOW() + ($2 * INTERVAL '1 second'))
        RETURNING id
    )SQL";
    constexpr auto INSERT_MAGIC_LING = R"SQL(
        insert into magic_links(token_id,identity_id,type)
            VALUES($1,$2,$3)
    )SQL";

}

int64_t TokenRepository::insertToken(pqxx::work &tx, pqxx::bytes token_hash, uint64_t ttl_seconds) {
    auto res = tx.exec_prepared(
        Statements::InsertToken.data(),
        token_hash,
        ttl_seconds);
    if (res.size() != 1) {
        throw std::runtime_error("InsertIdentity failed");
    }
    int64_t id = res[0]["id"].as<int64_t>();
    tx.commit();
    return id;
}

void TokenRepository::insertMagicLink(pqxx::work &tx, int64_t token_id, int64_t identity_id,
                                      std::string_view type) {
    auto res = tx.exec_prepared(
    Statements::InsertMagicLink.data(),
    token_id,
    identity_id,
    type
    );
}

void TokenRepository::prepare(pqxx::connection* conn) {
    conn->prepare(Statements::InsertMagicLink, INSERT_MAGIC_LING);
    conn->prepare(Statements::InsertToken, INSERT_TOKEN);
}
