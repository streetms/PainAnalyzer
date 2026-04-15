//
// Created by konstantin on 11.04.2026.
//

#include "DataBase.h"

#include <iostream>
#include "utils/alias.h"

std::string DataBase::getEnv(const char *name) {

    const char* val = std::getenv(name);
    if (!val) {
        throw std::runtime_error(std::string("Missing env: ") + name);
    }
    std::cout << name << ": " << val << std::endl;
    return val;
}

DataBase::DataBase() {
    conn.prepare(
    "add_patient",
    "INSERT INTO patient "
    "(phone,fullname,birthday,height,weight)"
    " VALUES ($1,$2,$3,$4,$5)"
    );
}

void DataBase::add_patient(const Patient &patient) {
    pqxx::work txn(conn);
    txn.exec_prepared("add_patient",
        patient.email,patient.fullName,patient.birthday,patient.height,patient.weight);
    txn.commit();
}
