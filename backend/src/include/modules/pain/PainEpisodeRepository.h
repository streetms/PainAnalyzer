//
// Created by konstantin on 14.06.2026.
//

#ifndef PAINANALYZER_PAINEPISODEREPOSITORY_H
#define PAINANALYZER_PAINEPISODEREPOSITORY_H

#include <string>
#include <string_view>
#include <vector>

#include "models/PainEpisode.h"
#include <cpppg/Database.h>
class PainEpisodeRepository {
public:
    void attachFeatures(db::Transaction& tx,const std::string& episode_id,const std::vector<std::string>& features,std::string_view type);
    ulid insertPainEpisode(db::Transaction &tx, const std::string& patient_id, std::string_view started_at, int intensity);
    std::vector<PainEpisode> getPainEpisodes(db::Transaction &tx, const std::string&,std::string_view from_date, std::string_view to_date);
    std::vector<PainEpisode> getPainEpisodes(db::Transaction &tx, const std::string&,std::string_view date);
    struct Statements {
        static constexpr std::string_view insertPainEpisode = "insert_pain_episode";
        static constexpr std::string_view attachFeatures = "attach_features";
        static constexpr std::string_view getPainEpisodes = "get_pain_episodes";
    };
    static void prepare(db::Connection& conn);
};



#endif //PAINANALYZER_PAINEPISODEREPOSITORY_H
