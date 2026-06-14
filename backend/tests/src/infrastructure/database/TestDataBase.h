//
// Created by konstantin on 13.06.2026.
//

#ifndef PAINANALYZER_TESTDATABASE_H
#define PAINANALYZER_TESTDATABASE_H
#include <pqxx/pqxx>

class TestDatabase
{
public:
    TestDatabase();
    ~TestDatabase();

    pqxx::connection& connection() { return conn; }
    pqxx::work& transaction() { return txn; }

private:
    pqxx::connection conn;
    pqxx::work txn;
};

#endif //PAINANALYZER_TESTDATABASE_H
