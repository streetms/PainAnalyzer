
#pragma once

#include <pqxx/pqxx>
#include "models/Patient.h"

class DataBase
{
    private:
    std::string getEnv(const char* name);

public:

    DataBase();

    void add_patient(const Patient &patient);

private:
    pqxx::connection conn;
};
