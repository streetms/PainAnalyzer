//
// Created by konstantin on 14.06.2026.
//

#include "modules/pain/PainEpisodeRepository.h"
namespace {
    constexpr auto INSERT_PAIN_EPISODE = R"SQL(
        insert into pain_episodes (patient_id,started_at,intensity)
            VALUES ($1,$2,$3)
        RETURNING id
    )SQL";
    constexpr auto ATTACH_FEATURES= R"SQL(
    INSERT INTO pain_episode_features (pain_episode_id, episode_features_id)
    SELECT $1, id
    FROM episode_features
    WHERE name = ANY($2)
      AND type = $3
)SQL";

}

void PainEpisodeRepository::attachFeatures(
    pqxx::work& tx,
    const ulid& episode_id,
    const std::vector<std::string>& features,
    std::string_view type)
{
    if (features.empty())
        return;

    tx.exec_prepared(
        Statements::attachFeatures.data(),
        episode_id,
        features,
        type
    );
}


ulid PainEpisodeRepository::insertPainEpisode(pqxx::work &tx, const ulid& patient_id, std::string_view started_at, int intensity) {
    auto res = tx.exec_prepared(
        Statements::insertPainEpisode.data(),
        patient_id,
        started_at,
        intensity);
    if (res.size() != 1)
        throw std::runtime_error("insert pain episode failed");
    ulid id = res[0]["id"].as<ulid>();

    return id;
}

void PainEpisodeRepository::prepare(pqxx::connection *conn) {
    conn->prepare(Statements::insertPainEpisode,INSERT_PAIN_EPISODE);
    conn->prepare(Statements::attachFeatures,ATTACH_FEATURES);
}
