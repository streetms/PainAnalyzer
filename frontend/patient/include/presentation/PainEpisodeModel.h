//
// Created by konstantin on 17.06.2026.
//

#ifndef PAINANALYZER_PAINEPISODEMODEL_H
#define PAINANALYZER_PAINEPISODEMODEL_H

#pragma once
#include <QAbstractListModel>
#include <QVariantList>  // Добавили для графика
#include <QVariantMap>   // Добавили для графика
#include <QDateTime>     // Добавили для работы с датами
#include <vector>
#include "models/PainEpisode.h" // Ваш общий файл со структурой

class PainEpisodeModel : public QAbstractListModel {
    Q_OBJECT

public:
    enum EpisodeRoles {
        TypesRole ,
        TriggersRole,
        SymptomsRole,
        AurasRole,
        DrugsRole,
        StartedAtRole,
        IntensityRole,
        SectionDateRole,
        TimeStringRole
    };

    explicit PainEpisodeModel(QObject *parent = nullptr);
    // Метод для загрузки данных (вызовете его, когда придут данные с сервера)
    void setEpisodes(const std::vector<PainEpisode>& episodes);

    // Обязательные методы QAbstractListModel
    int rowCount(const QModelIndex &parent = QModelIndex()) const override ;

    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    Q_INVOKABLE QVariantList getChartData(int year, int month);
    const std::vector<PainEpisode>& episodes() const;
protected:
    QHash<int, QByteArray> roleNames() const override {
        QHash<int, QByteArray> roles;
        roles[TypesRole] = "types";
        roles[TriggersRole] = "triggers";
        roles[SymptomsRole] = "symptoms";
        roles[AurasRole] = "auras";
        roles[DrugsRole] = "drugs";
        roles[StartedAtRole] = "startedAt";
        roles[IntensityRole] = "intensity";
        roles[SectionDateRole] = "sectionDate";
        roles[TimeStringRole] = "timeString";
        return roles;
    }

private:
    std::vector<PainEpisode> episodes_;
    QStringList toQStringList(const std::vector<std::string>& vec) const;
    // Вспомогательный метод парсинга (с фиксом формата PostgreSQL)
    QDateTime parseDate(const std::string& dbDate) const;
};


#endif //PAINANALYZER_PAINEPISODEMODEL_H
