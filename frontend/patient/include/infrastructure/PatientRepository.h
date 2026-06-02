//
// Created by konstantin on 31.05.2026.
//

#ifndef PAINAPP_PATIENTREPOSITORY_H
#define PAINAPP_PATIENTREPOSITORY_H
#include "core/infrastructure/network/ApiClient.h"
#include "models/PainEpisode.h"

class PatientRepository {
private:
    ApiClient api;
    public:
    void savePainEpisode(const PainEpisode& episode);
};


#endif //PAINAPP_PATIENTREPOSITORY_H
