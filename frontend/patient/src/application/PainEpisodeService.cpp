//
// Created by konstantin on 18.06.2026.
//

#include "application/PainEpisodeService.h"

PainEpisodeService::PainEpisodeService(QObject *parent)  {
    connect(&repository_, &PainEpisodeRepository::episodesFetched,
            this, &PainEpisodeService::episodesReady);
}

void PainEpisodeService::loadEpisodes(QString from, QString to) {
    std::string date1 = from.toStdString();
    std::string date2 = to.toStdString();
    repository_.fetchEpisodesFromNetwork(date1, date2);
}

// void PainEpisodeService::loadEpisodes(std::string_view from, std::string_view to) {
//
// }
