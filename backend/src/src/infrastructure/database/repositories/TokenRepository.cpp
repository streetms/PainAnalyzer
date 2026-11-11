//
// Created by konstantin on 26.05.2026.
//

#include "infrastructure/database/repositories/TokenRepository.h"

#include <charconv>
#include <stdexcept>
#include <string>
#include <utility>


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

int64_t TokenRepository::insertToken(db::Transaction &tx, db::Bytes token_hash, uint64_t ttl_seconds) {
    const db::Parameter parameters[]{std::move(token_hash), ttl_seconds};
    auto res = tx.exec_prepared(Statements::InsertToken, parameters);
    if (res.size() != 1) {
        throw std::runtime_error("InsertToken failed");
    }
    const auto value = res.get(0, "id");
    int64_t id{};
    std::from_chars(
        value->data(), value->data() + value->size(), id);
    return id;
}

void TokenRepository::insertMagicLink(db::Transaction &tx, int64_t token_id, int64_t identity_id,
                                      std::string_view type) {
    const db::Parameter parameters[]{token_id, identity_id, std::string{type}};
    tx.exec_prepared(Statements::InsertMagicLink, parameters);
}

void TokenRepository::prepare(db::Connection& conn) {
    conn.prepare(Statements::InsertMagicLink, INSERT_MAGIC_LING);
    conn.prepare(Statements::InsertToken, INSERT_TOKEN);
}
