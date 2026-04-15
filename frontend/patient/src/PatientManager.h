//
// Created by konstantin on 09.04.2026.
//

#pragma once
#include "models/Patient.h"
#include "user/UserManager.h"
#include "network/AuthManager.h"
class PatientManager : public UserManager {
private:
    Q_OBJECT
    AuthManager* _authManager = nullptr;
public:
    // static PatientManager* instance();
    PatientManager();
public slots:
    void registerPatient();
    void setEmail(QString email);
    void setFullName(QString fullName);
    void setBirthday(QDate birthday);
    void setHeight(int height);
    void setWeight(int weight);
    Patient* getPatient();
};
