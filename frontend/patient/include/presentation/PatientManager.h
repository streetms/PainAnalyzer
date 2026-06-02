//
// Created by konstantin on 09.04.2026.
//

#pragma once
#include "models/Patient.h"
#include "models/PainEpisode.h"
#include "application/PatientService.h"
#include "core/presentation/UiExecutor.h"

class PatientManager : public QObject  {
protected:
    ~PatientManager() = default;

private:
    Q_OBJECT

    PainEpisode _painEpisode;
    PatientService _patientService;
    Patient _patient;
    UiExecutor m_executor;
public:

    PatientManager();

    signals:
        void errorOccurred(const QString& message);

public slots:
    void savePainEpisode();
    void setTriggers(const QStringList& triggers);
    void setAuras(const QStringList& auras);
    void setSymptoms(const QStringList& symptoms);
    void setDrugs(const QStringList& drugs);
    void setPainTypes(const QStringList& painTypes);
    void setEmail(QString email);
    void setFullName(QString fullName);
    void setBirthday(QDate birthday);
    void setHeight(int height);
    void setWeight(int weight);
    PainEpisode* getPainEpisode();
};
