//
// Created by konstantin on 09.04.2026.
//

#pragma once
#include "models/Patient.h"
#include "user/UserManager.h"
#include "network/NetworkManager.h"
class PatientManager : public UserManager {
private:
    Q_OBJECT
public:
    static PatientManager* instance();

public slots:
    void upload();
    void setPhone(QString phone);
    void setFullName(QString fullName);
    void setBirthday(QString birthday);
    void setHeight(int height);
    void setWeight(int weight);
    Patient* getPatient();
};
