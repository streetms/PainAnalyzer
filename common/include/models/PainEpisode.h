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
    std::vector<std::string> drugs;
    std::string started_at;
    int intensity;
    void clear() {
        types.clear();
        triggers.clear();
        symptoms.clear();
        auras.clear();
        drugs.clear();
        started_at.clear();
        intensity = 0;
    }
};

NLOHMANN_DEFINE_TYPE_NON_INTRUSIVE(PainEpisode,types, triggers, symptoms, auras, drugs,started_at,intensity);
#endif //PAINAPP_PAINEPISODE_H
