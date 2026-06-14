//
// Created by konstantin on 14.06.2026.
//

#ifndef PAINANALYZER_PAINEPISODEREPOSITORY_H
#define PAINANALYZER_PAINEPISODEREPOSITORY_H

#include <pqxx/pqxx>

#include "utils/alias.h"

class PainEpisodeRepository {
private:

public:
    void attachFeatures(pqxx::work& tx,const ulid& episode_id,const std::vector<std::string>& features,std::string_view type);
    ulid insertPainEpisode(pqxx::work &tx, const ulid& patient_id, std::string_view started_at, int intensity);
    // void attachFeatureToEpisode(pqxx::work &tx, const ulid& episode_id, const ulid& feature_id);
    struct Statements {
        static constexpr std::string_view insertPainEpisode = "insert_pain_episode";
        static constexpr std::string_view attachFeatures = "attach_features";
    };
    static void prepare(pqxx::connection* conn);
};



#endif //PAINANALYZER_PAINEPISODEREPOSITORY_H
