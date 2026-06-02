#include "presentation/PatientManager.h"
#include <QJsonObject>

// PatientManager * PatientManager::instance() {
//     static PatientManager manager;
//     manager._user = new Patient;
//     return &manager;
// }

PatientManager::PatientManager() {
    connect(&m_executor, &UiExecutor::errorOccurred,
            this, &PatientManager::errorOccurred);
    // _user = new Patient();
    // _authManager = new AuthManager();
}

void PatientManager::savePainEpisode() {
    m_executor.run([this]() {
        _patientService.savePainEpisode(_painEpisode);
    });

}

void PatientManager::setTriggers(const QStringList& triggers)  {
    _painEpisode.triggers.reserve(triggers.size());
    for (auto& trigger : triggers) {
        _painEpisode.triggers.push_back(trigger.toStdString());
    }
}

void PatientManager::setAuras(const QStringList& auras) {
    _painEpisode.triggers.reserve(auras.size());
    for (auto& aura : auras) {
        _painEpisode.auras.push_back(aura.toStdString());
    }
}

void PatientManager::setSymptoms(const QStringList& symptoms) {
    _painEpisode.symptoms.reserve(symptoms.size());
    for (auto& symptom : symptoms) {
        _painEpisode.symptoms.push_back(symptom.toStdString());
    }
}

void PatientManager::setDrugs(const QStringList& drugs) {
    _painEpisode.drugs.reserve(drugs.size());
    for (auto& drug : drugs) {
        _painEpisode.drugs.push_back(drug.toStdString());
    }
}

void PatientManager::setPainTypes(const QStringList &painTypes) {
    _painEpisode.types.reserve(painTypes.size());
    for (auto& type : painTypes) {
        _painEpisode.types.push_back(type.toStdString());
    }
}


void PatientManager::setEmail(QString email) {
    _patient.email = email.toStdString();
}

void PatientManager::setFullName(QString fullName) {
    _patient.fullName = fullName.toStdString();
}

void PatientManager::setBirthday(QDate birthday) {
    _patient.birthday = birthday.toString(Qt::ISODate).toStdString();
}

void PatientManager::setHeight(int height) {
    _patient.height = height;
}

void PatientManager::setWeight(int weight) {
    _patient.weight = weight;
}

PainEpisode * PatientManager::getPainEpisode() {
    return &_painEpisode;
}
