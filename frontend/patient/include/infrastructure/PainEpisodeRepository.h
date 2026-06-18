//
// Created by konstantin on 18.06.2026.
//

#ifndef PAINANALYZER_PAINEPISODEREPOSITORY_H
#define PAINANALYZER_PAINEPISODEREPOSITORY_H
#include <QObject>
#include "core/infrastructure/network/ApiClient.h"
#include "models/PainEpisode.h"

class PainEpisodeRepository : public QObject {
    Q_OBJECT
    ApiClient api;
public:
    // Делает запрос в сеть и испускает сигнал, когда данные готовы
    void fetchEpisodesFromNetwork(std::string_view from, std::string_view to);
    signals:
        void episodesFetched(std::vector<PainEpisode> episodes);
};

#endif //PAINANALYZER_PAINEPISODEREPOSITORY_H
