//
// Created by konstantin on 26.05.2026.
//

#ifndef PAINAPP_IDENTITIYREPOSITORY_H
#define PAINAPP_IDENTITIYREPOSITORY_H
#include <cpppg/Transaction.h>

#include <cstdint>
#include <string_view>

#include <cpppg/Connection.h>

class IdentityRepository {

public:
    int64_t insertIdentity(db::Transaction &tx, std::string_view identifier_type, std::string_view identifier) const;
    struct Statements {
        static constexpr std::string_view InsertIdentity = "insert_identity";
        static constexpr std::string_view AttachIdentity = "attach_identity";
    };
    static void prepare(db::Connection& conn);
};




#endif //PAINAPP_IDENTITIYREPOSITORY_H
