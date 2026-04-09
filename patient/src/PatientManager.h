//
// Created by konstantin on 09.04.2026.
//

#ifndef PAINAPP_PATIENTMANAGER_H
#define PAINAPP_PATIENTMANAGER_H

#include "patient.h"
#include "user/UserManager.h"

class PatientManager : public UserManager {
    Q_OBJECT
public:
    static PatientManager* instance();
public slots:
    Patient* getPatient();
};



#endif //PAINAPP_PATIENTMANAGER_H
