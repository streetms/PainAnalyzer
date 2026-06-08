#include "presentation/PatientViewModel.h"
#include <QJsonObject>

// PatientViewModel * PatientViewModel::instance() {
//     static PatientViewModel manager;
//     manager._user = new Patient;
//     return &manager;
// }

PatientViewModel::PatientViewModel() {
    connect(&m_executor, &UiExecutor::errorOccurred,
            this, &PatientViewModel::errorOccurred);
    // _user = new Patient();
    // _authManager = new AuthManager();
}

void PatientViewModel::savePainEpisode() {
    m_executor.run([this]() {
        _patientService.savePainEpisode(_painEpisode);
        _painEpisode.clear();
    });
}

void PatientViewModel::setTime(QString ISOString) {
    _painEpisode.started_at = ISOString.toStdString();
}

void PatientViewModel::setIntensity(int intensity) {
    _painEpisode.intensity = intensity;
}

void PatientViewModel::setTriggers(const QStringList& triggers)  {
    _painEpisode.triggers.reserve(triggers.size());
    for (auto& trigger : triggers) {
        _painEpisode.triggers.push_back(trigger.toStdString());
    }
}

void PatientViewModel::setAuras(const QStringList& auras) {
    _painEpisode.triggers.reserve(auras.size());
    for (auto& aura : auras) {
        _painEpisode.auras.push_back(aura.toStdString());
    }
}

void PatientViewModel::setSymptoms(const QStringList& symptoms) {
    _painEpisode.symptoms.reserve(symptoms.size());
    for (auto& symptom : symptoms) {
        _painEpisode.symptoms.push_back(symptom.toStdString());
    }
}

void PatientViewModel::setDrugs(const QStringList& drugs) {
    _painEpisode.drugs.reserve(drugs.size());
    for (auto& drug : drugs) {
        _painEpisode.drugs.push_back(drug.toStdString());
    }
}

void PatientViewModel::setPainTypes(const QStringList &painTypes) {
    _painEpisode.types.reserve(painTypes.size());
    for (auto& type : painTypes) {
        _painEpisode.types.push_back(type.toStdString());
    }
}


void PatientViewModel::setEmail(QString email) {
    _patient.email = email.toStdString();
}

void PatientViewModel::setFullName(QString fullName) {
    _patient.fullName = fullName.toStdString();
}

void PatientViewModel::setBirthday(QDate birthday) {
    _patient.birthday = birthday.toString(Qt::ISODate).toStdString();
}

void PatientViewModel::setHeight(int height) {
    _patient.height = height;
}

void PatientViewModel::setWeight(int weight) {
    _patient.weight = weight;
}

PainEpisode * PatientViewModel::getPainEpisode() {
    return &_painEpisode;
}
