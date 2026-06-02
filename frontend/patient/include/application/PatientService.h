//
// Created by konstantin on 31.05.2026.
//

#ifndef PAINAPP_PATIENTSERVICE_H
#define PAINAPP_PATIENTSERVICE_H
#include <QNetworkReply>

#include "infrastructure/PatientRepository.h"
#include "models/PainEpisode.h"
class PatientService {
    PatientRepository _patientRepository;
    public:
    void savePainEpisode(const PainEpisode& episode);

};


#endif //PAINAPP_PATIENTSERVICE_H
