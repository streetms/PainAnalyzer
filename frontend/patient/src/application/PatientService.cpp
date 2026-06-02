//
// Created by konstantin on 31.05.2026.
//

#include "application/PatientService.h"


void PatientService::savePainEpisode(const PainEpisode& episode) {
    if (episode.types.empty()) {
        throw std::invalid_argument("не указан тип боли");
    }
    if (episode.symptoms.empty()) {
        throw std::invalid_argument("не указаны симптомы");
    }
    if (episode.triggers.empty()) {
        throw std::invalid_argument("не указаны триггеры");
    }
    if (episode.auras.empty()) {
        throw std::invalid_argument("не указаны ауры");
    }
    _patientRepository.savePainEpisode(episode);
}
