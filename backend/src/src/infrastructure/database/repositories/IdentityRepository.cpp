//
// Created by konstantin on 26.05.2026.
//

#include "infrastructure/database/repositories/IdentityRepository.h"

#include <charconv>
#include <stdexcept>
#include <string>

#include "cpppg/Connection.h"

namespace {
    constexpr auto INSERT_IDENTITY = R"SQL(
        insert into auth_identities (type,identifier)
            VALUES ($1,$2)
        RETURNING id
    )SQL";
}

int64_t IdentityRepository::insertIdentity(db::Transaction &tx, std::string_view type, std::string_view identifier) const {
    const db::Parameter parameters[]{std::string{type}, std::string{identifier}};
    auto res = tx.exec_prepared(Statements::InsertIdentity, parameters);
    if (res.size() != 1)
        throw std::runtime_error("InsertIdentity failed");
    const auto value = res.get(0, "id");
    int64_t id{};
    std::from_chars(
        value->data(), value->data() + value->size(), id);
    return id;
}

void IdentityRepository::prepare(db::Connection& conn) {
    conn.prepare(Statements::InsertIdentity,INSERT_IDENTITY);

}
