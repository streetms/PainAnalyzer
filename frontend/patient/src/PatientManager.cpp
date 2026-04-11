#include "PatientManager.h"
#include <QJsonObject>
PatientManager * PatientManager::instance() {
    static PatientManager manager;
    manager._user = new Patient;
    return &manager;
}

void PatientManager::upload() {
    auto networkManager = NetworkManager::instance();
    auto patient = getPatient();
    networkManager->sendRequest(
        "create_patient",
                *patient
        );
}

void PatientManager::setPhone(QString phone) {
    auto patient = getPatient();
    patient->phone = phone.toStdString();
}

void PatientManager::setFullName(QString fullName) {
    auto patient = getPatient();
    patient->fullName = fullName.toStdString();
}

void PatientManager::setBirthday(QString birthday) {
    auto patient = getPatient();
    patient->birthday = birthday.toStdString();
}

void PatientManager::setHeight(int height) {
    auto patient = getPatient();
    patient->height = height;
}

void PatientManager::setWeight(int weight) {
    auto patient = getPatient();
    patient->weight = weight;
}

Patient* PatientManager::getPatient() {
    return dynamic_cast<Patient*>(_user);
}
