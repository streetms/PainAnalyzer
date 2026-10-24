//
// Created by konstantin on 03.06.2026.
//

#ifndef PAINAPP_PAINEPISODESERVICE_H
#define PAINAPP_PAINEPISODESERVICE_H
#include "cpppg/Database.h"
#include "modules/pain/PainEpisodeRepository.h"
#include "models/PainEpisode.h"

#include <string>

class PainEpisodeService {
    db::Database& db_;
    PainEpisodeRepository painEpisodeRepository;
public:
    PainEpisodeService(db::Database& db) : db_(db) {}
    net::awaitable<void> insertPainEpisode(const PainEpisode& episode);
    net::awaitable<std::vector<PainEpisode>> getPainEpisodes(const ulid& patient_id, std::string_view from_date, std::string_view to_date);
    net::awaitable<std::vector<PainEpisode>> getPainEpisodes(const ulid& patient_id,std::string_view date);
};


#endif //PAINAPP_PAINEPISODESERVICE_H
