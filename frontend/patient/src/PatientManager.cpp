#include "PatientManager.h"

PatientManager * PatientManager::instance() {
    static PatientManager manager;
    manager._user = new Patient;
    return &manager;
}

void PatientManager::upload() {
    auto networkManager = NetworkManager::instance();
    auto patient = getPatient();
    networkManager->sendRequest(
        "create_patient",{
                patient->toJson()}
        );
}

Patient* PatientManager::getPatient() {
    return dynamic_cast<Patient*>(_user);
}
