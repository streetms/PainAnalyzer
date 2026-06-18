//
// Created by konstantin on 18.06.2026.
//

#include "presentation/PainEpisodeViewModel.h"

PainEpisodesViewModel::PainEpisodesViewModel(QObject *parent) {

    // Когда Service скачал и подготовил данные, кладем их в Model
    connect(&service_, &PainEpisodeService::episodesReady,
            this, [this](std::vector<PainEpisode> episodes) {
        listModel_.setEpisodes(std::move(episodes)); // Модель просто обновляет UI
    });
}
