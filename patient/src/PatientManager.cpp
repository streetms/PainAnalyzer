//
// Created by konstantin on 09.04.2026.
//

#include "PatientManager.h"

PatientManager * PatientManager::instance() {
    static PatientManager manager;
    manager._user = new Patient;
    return &manager;
}

Patient* PatientManager::getPatient() {
    return dynamic_cast<Patient*>(_user);
}
