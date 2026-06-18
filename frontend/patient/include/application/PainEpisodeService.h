//
// Created by konstantin on 18.06.2026.
//

#ifndef PAINANALYZER_PAINEPISODESERVICE_H
#define PAINANALYZER_PAINEPISODESERVICE_H
#include <QObject>
#include "infrastructure/PainEpisodeRepository.h"
#include "models/PainEpisode.h"

class PainEpisodeService : public QObject {
    Q_OBJECT
public:
    PainEpisodeService(QObject* parent = nullptr);
    void loadEpisodes(QString from, QString to);

signals:
    void episodesReady(std::vector<PainEpisode> episodes);

private:
    PainEpisodeRepository repository_;
};

#endif //PAINANALYZER_PAINEPISODESERVICE_H
