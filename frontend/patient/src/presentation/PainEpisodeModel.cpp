//
// Created by konstantin on 17.06.2026.
//

#include "presentation/PainEpisodeModel.h"

PainEpisodeModel::PainEpisodeModel(QObject *parent)  : QAbstractListModel(parent) {

}

void PainEpisodeModel::setEpisodes(const std::vector<PainEpisode> &episodes) {
     beginResetModel();

    episodes_ = episodes;
    std::sort(episodes_.begin(), episodes_.end(), [](const PainEpisode& a, const PainEpisode& b) {
        return a.started_at > b.started_at;
    });
    endResetModel();
}

int PainEpisodeModel::rowCount(const QModelIndex &parent) const {
    if (parent.isValid()) return 0;
    return episodes_.size();
}

QVariant PainEpisodeModel::data(const QModelIndex &index, int role) const {
    if (!index.isValid() || index.row() >= episodes_.size())
        return QVariant();

    const auto& episode = episodes_[index.row()];

    switch (role) {
        case TypesRole:      return toQStringList(episode.types);
        case TriggersRole:   return toQStringList(episode.triggers);
        case SymptomsRole:   return toQStringList(episode.symptoms);
        case AurasRole:      return toQStringList(episode.auras);
        // case DrugsRole:      return toQStringList(episode.drugs);
        case StartedAtRole:  return QString::fromStdString(episode.started_at);
        case IntensityRole:  return episode.intensity;
        case SectionDateRole: {
            QDateTime dt = parseDate(episode.started_at);
            if (!dt.isValid()) return "Неизвестная дата";

            // QLocale позволяет вывести дату на языке системы пользователя
            return QLocale().toString(dt.date(), "d MMMM yyyy");
        }
        case TimeStringRole: {
            QDateTime dt = parseDate(episode.started_at);
            return dt.isValid() ? dt.time().toString("HH:mm") : "";
        }
        default: return QVariant();
    }
}

QVariantList PainEpisodeModel::getChartData(int year, int month) {
    QVariantList chartData;

    QDate targetDate(year, month, 1);
    int daysInMonth = targetDate.daysInMonth();
    
    std::vector<int> maxPainPerDay(daysInMonth, 0);

    for (const auto& ep : episodes_) {

        // Теперь строка выглядит идеально для Qt: "2026-06-14T16:36:26.562000+00:00"
        QDateTime dt =parseDate(ep.started_at);
        if (dt.isValid() && dt.date().year() == year && dt.date().month() == month) {
            int dayIndex = dt.date().day() - 1;
            if (ep.intensity > maxPainPerDay[dayIndex]) {
                maxPainPerDay[dayIndex] = ep.intensity; // сохраняем максимум
            }
        }
    }

    // Упаковываем результат для QML
    for (int i = 0; i < daysInMonth; ++i) {
        QVariantMap point;
        point["day"] = i + 1;
        point["intensity"] = maxPainPerDay[i];
        chartData.append(point);
    }

    return chartData;
}

QStringList PainEpisodeModel::toQStringList(const std::vector<std::string>& vec) const {
    QStringList list;
    list.reserve(vec.size());
    for (const auto& str : vec) {
        list.append(QString::fromStdString(str));
    }
    return list;
}

QDateTime PainEpisodeModel::parseDate(const std::string &dbDate) const {
    QString rawDate = QString::fromStdString(dbDate);
    if (rawDate.length() > 10 && rawDate[10] == ' ') rawDate[10] = 'T';
    rawDate.remove(' ');
    return QDateTime::fromString(rawDate, Qt::ISODate);
}
