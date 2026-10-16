//
// Created by konstantin on 03.06.2026.
//

#include "modules/pain/PainEpisodeService.h"
#include <iostream>


net::awaitable<void> PainEpisodeService::insertPainEpisode(const PainEpisode &episode) {
    try {
        co_await db_.run([&](pqxx::work& tx) {
            std::string patient_id = "01KT97H6RJ74K2CNFHP7NPS1TA";
            auto episode_id = painEpisodeRepository.insertPainEpisode(tx,patient_id,episode.started_at,episode.intensity);
            painEpisodeRepository.attachFeatures(tx,episode_id,episode.types,"pain_type");
            painEpisodeRepository.attachFeatures(tx,episode_id,episode.auras,"aura");
            painEpisodeRepository.attachFeatures(tx,episode_id,episode.symptoms,"symptom");
            painEpisodeRepository.attachFeatures(tx,episode_id,episode.triggers,"trigger");
            std::cout << "inserted" << std::endl;
        });
    } catch (std::exception& e) {
        std::cerr << "Exception: " << e.what() << std::endl;
    }
}

net::awaitable<std::vector<PainEpisode>> PainEpisodeService::getPainEpisodes(const ulid& patient_id,std::string_view from_date, std::string_view to_date) {
    co_return co_await db_.run([&](pqxx::work& tx) {

        auto res = painEpisodeRepository.getPainEpisodes(tx,patient_id,from_date,to_date);
        return res;
    });
}

net::awaitable<std::vector<PainEpisode>> PainEpisodeService::getPainEpisodes(const ulid& patient_id,std::string_view date) {
    co_return co_await getPainEpisodes(patient_id,date,date);
}
