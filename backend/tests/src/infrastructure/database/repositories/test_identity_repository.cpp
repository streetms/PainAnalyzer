//
// Created by konstantin on 13.06.2026.
//
#include <gtest/gtest.h>

#include "infrastructure/database/repositories/IdentityRepository.h"
#include "../TestDataBase.h"

TEST(IdentityRepositoryTest, CanInsertUser)
{
    TestDatabase db;
    IdentityRepository repo;
    int id = repo.insertIdentity(db.transaction(),"email","konstantin.isakov.2003@mail.ru");
    ASSERT_EQ(id,8);

    auto r = db.transaction().exec(
        "SELECT login FROM users WHERE id = " + db.transaction().quote(id));

    ASSERT_EQ(r.size(), 1);
    // EXPECT_EQ(r[0][0].as<std::string>(), "john");
}