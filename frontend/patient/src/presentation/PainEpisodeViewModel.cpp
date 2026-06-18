//
// Created by konstantin on 18.06.2026.
//

#include "presentation/PainEpisodeViewModel.h"
#include <QTextDocument>
#include <QPdfWriter>
#include <QFile>
#include <QStandardPaths>
PainEpisodesViewModel::PainEpisodesViewModel(QObject *parent) {

    // Когда Service скачал и подготовил данные, кладем их в Model
    connect(&service_, &PainEpisodeService::episodesReady,
            this, [this](std::vector<PainEpisode> episodes) {
        listModel_.setEpisodes(std::move(episodes)); // Модель просто обновляет UI
    });
}

bool PainEpisodesViewModel::exportFullReportToPdf(const QString &graphImagePath) {
     // 1. Формируем HTML документ
    QString html = "<h1 style='text-align: center;'>Отчет о приступах</h1>";

    // Вставляем картинку графика (QTextDocument понимает локальные пути)
    html += QString("<div style='text-align: center;'><img src='%1' width='600'></div><br><br>")
                .arg(QUrl::fromLocalFile(graphImagePath).toString());

    // 2. Начинаем таблицу для списка
    html += "<table border='1' cellspacing='0' cellpadding='8' width='100%' style='border-collapse: collapse;'>";
    html += "<tr style='background-color: #4a5580; color: white;'>"
            "<th>Дата</th>"
            "<th>Интенсивность</th>"
            "<th>дополнительная информация</th>"
            "</tr>";

    // 3. ПРОХОДИМ ПО ВСЕМУ МАССИВУ ДАННЫХ!
    // ВАЖНО: Замените m_episodes на реальное имя вашего std::vector в классе
    for (const auto& episode : listModel_.episodes()) {
        html += "<tr>";
        // Замените поля (.date, .intensity) на реальные поля вашей структуры PainEpisode
        html += "<td>" + episode.started_at + "</td>";
        html += "<td style='text-align: center;'>" + QString::number(episode.intensity) + " / 10</td>";

        html += "<td>";
        html += "триггеры: " + to_string(episode.triggers);
        html += "<br>";
        html += "симптомы: " + to_string(episode.symptoms);
        html += "<br>";
        html += "ауры: " + to_string(episode.auras);
        html += "<br>";
        html += "тип боли: " + to_string(episode.types);
        html += "</td>";
        html += "</tr>";
    }
    html += "</table>";

    // 4. Генерируем PDF
    QTextDocument document;
    document.setHtml(html);

    // Сохраняем в папку "Документы"
    QString docsPath = QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation);
    QString pdfFilePath = docsPath + "/FullPainReport.pdf";

    QPdfWriter pdfWriter(pdfFilePath);
    pdfWriter.setPageSize(QPageSize(QPageSize::A4));
    pdfWriter.setPageMargins(QMarginsF(15, 15, 15, 15), QPageLayout::Millimeter);
    pdfWriter.setResolution(300); // Высокое качество печати

    // Эта магическая команда сама разобьет таблицу на нужное количество страниц!
    document.print(&pdfWriter);

    // Удаляем временную картинку графика
    QFile::remove(graphImagePath);

    qDebug() << "Полный многостраничный PDF сохранен:" << pdfFilePath;
    return true;
}

std::string PainEpisodesViewModel::to_string(std::vector<std::string> array) {
    std::string res;
    if (not array.empty()) {
        for (int i = 0; i < array.size()-1; i++) {
            res += array[i] + ";";
        }
        res += array.back();
    }
    return res;
}
