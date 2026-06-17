//
// Created by konstantin on 31.05.2026.
//

#ifndef PAINAPP_PAINEPISODE_H
#define PAINAPP_PAINEPISODE_H
#include <vector>
#include <string>
struct PainEpisode {
    std::vector<std::string> types;
    std::vector<std::string> triggers;
    std::vector<std::string> symptoms;
    std::vector<std::string> auras;
    std::string started_at;
    int intensity;
    void clear() {
        types.clear();
        triggers.clear();
        symptoms.clear();
        auras.clear();
        started_at.clear();
        intensity = 0;
    }
    bool operator==(const PainEpisode& other) const{
        return this->types == other.types and
        this->triggers == other.triggers
        and this->symptoms == other.symptoms
        and this->auras == other.auras
        and this->started_at == other.started_at
        and this->intensity == other.intensity;
    }
};

NLOHMANN_DEFINE_TYPE_NON_INTRUSIVE(PainEpisode,types, triggers, symptoms, auras, started_at,intensity);
#endif //PAINAPP_PAINEPISODE_H
