//
// Created by konstantin on 18.06.2026.
//
#pragma once
#include <QObject>
#include "application/PainEpisodeService.h"
#include "PainEpisodeModel.h"
class PainEpisodesViewModel : public QObject {
    Q_OBJECT
    Q_PROPERTY(PainEpisodeModel* listModel READ listModel)

public:
    PainEpisodesViewModel(QObject* parent = nullptr);

    PainEpisodeModel* listModel()  { return &listModel_; }

public slots:
    // Этот метод мы вызываем из QML (например, по кнопке "Обновить")
    void refresh(QString from, QString to) {
        service_.loadEpisodes(std::move(from),std::move(to));
        int x = 10;
    }

private:
    PainEpisodeService service_;
    PainEpisodeModel listModel_;
};
