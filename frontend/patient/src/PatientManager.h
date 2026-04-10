//
// Created by konstantin on 09.04.2026.
//

#pragma once
#include "patient.h"
#include "user/UserManager.h"
#include "network/NetworkManager.h"
class PatientManager : public UserManager {
private:
    Q_OBJECT
public:
    static PatientManager* instance();

public slots:
    void upload();
    Patient* getPatient();
};
