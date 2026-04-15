#include "PatientManager.h"
#include <QJsonObject>
// PatientManager * PatientManager::instance() {
//     static PatientManager manager;
//     manager._user = new Patient;
//     return &manager;
// }

PatientManager::PatientManager() {
    _user = new Patient();
    _authManager = new AuthManager();
}

void PatientManager::registerPatient() {
    _authManager->registerUser(*getPatient());
}



void PatientManager::setEmail(QString email) {
    auto patient = getPatient();
    patient->email = email.toStdString();
}

void PatientManager::setFullName(QString fullName) {
    auto patient = getPatient();
    patient->fullName = fullName.toStdString();
}

void PatientManager::setBirthday(QDate birthday) {
    auto patient = getPatient();
    patient->birthday = birthday.toString(Qt::ISODate).toStdString();
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
