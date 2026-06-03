//
// Created by konstantin on 26.05.2026.
//

#include "infrastructure/database/repositories/IdentityRepository.h"

#include <iostream>

namespace {
    constexpr auto INSERT_IDENTITY = R"SQL(
        insert into auth_identities (type,identifier)
            VALUES ($1,$2)
        RETURNING id
    )SQL";
}

int64_t
IdentityRepository::insertIdentity(pqxx::work &tx, std::string_view type, std::string_view identifier) const {
    auto res = tx.exec_prepared(
        Statements::InsertIdentity.data(),
        type,
        identifier
        );
    if (res.size() != 1)
        throw std::runtime_error("InsertIdentity failed");
    int64_t id = res[0]["id"].as<int64_t>();
    return id;
}

void IdentityRepository::prepare(pqxx::connection *conn) {
    conn->prepare(Statements::InsertIdentity,INSERT_IDENTITY);

}