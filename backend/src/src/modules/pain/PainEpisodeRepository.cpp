//
// Created by konstantin on 14.06.2026.
//

#include "modules/pain/PainEpisodeRepository.h"

#include <iostream>

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



    constexpr auto GET_PAIN_EPISODES = R"SQL(
SELECT
    json_build_object(
        'started_at', pe.started_at::text,  -- приводим дату к строке для std::string
        'intensity', pe.intensity,

        -- Выбираем только имена (ef.name) и раскладываем их по массивам в зависимости от типа
        'types', COALESCE(json_agg(ef.name) FILTER (WHERE ef.type = 'pain_type'), '[]'::json),
        'triggers', COALESCE(json_agg(ef.name) FILTER (WHERE ef.type = 'trigger'), '[]'::json),
        'symptoms', COALESCE(json_agg(ef.name) FILTER (WHERE ef.type = 'symptom'), '[]'::json),
        'auras', COALESCE(json_agg(ef.name) FILTER (WHERE ef.type = 'aura'), '[]'::json)
    ) AS episode_json
FROM pain_episodes pe
LEFT JOIN pain_episode_features pef ON pe.id = pef.pain_episode_id
LEFT JOIN episode_features ef ON pef.episode_features_id = ef.id
WHERE
    pe.patient_id = $1
    AND pe.started_at >= $2
    AND pe.started_at < ($3::date + INTERVAL '1 day')
GROUP BY pe.id
ORDER BY pe.started_at
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


std::vector<PainEpisode> PainEpisodeRepository::getPainEpisodes(pqxx::work &tx, const ulid& patient_id,std::string_view from_date, std::string_view to_date) {
    auto res = tx.exec_prepared(Statements::getPainEpisodes.data(),
    patient_id,
    from_date,
        to_date);
    std::vector<PainEpisode> episodes;

    for (const auto& row : res) {
        // 1. Берем готовую JSON строку из базы
        std::string json_str = row["episode_json"].c_str();
        PainEpisode ep = nlohmann::json::parse(json_str).get<PainEpisode>();
        episodes.push_back(std::move(ep));
    }
    return episodes;
}

std::vector<PainEpisode> PainEpisodeRepository::getPainEpisodes(pqxx::work &tx, const ulid& patient_id,std::string_view date) {
    return getPainEpisodes(tx,patient_id,date,date);
}

void PainEpisodeRepository::prepare(pqxx::connection *conn) {
    conn->prepare(Statements::insertPainEpisode,INSERT_PAIN_EPISODE);
    conn->prepare(Statements::attachFeatures,ATTACH_FEATURES);
    conn->prepare(Statements::getPainEpisodes,GET_PAIN_EPISODES);
}