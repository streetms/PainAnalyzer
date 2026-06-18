#include <qfile.h>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickStyle>
#include <QQmlContext>
#include "presentation/PatientViewModel.h"
#include "presentation/SettingsViewModel.h"
#include "presentation/PainEpisodeViewModel.h"


int main(int argc, char *argv[]) {

    QGuiApplication app(argc, argv);

    QQuickStyle::setStyle("Material");

    QQmlApplicationEngine engine;

    PatientViewModel *patientManager = new PatientViewModel();
    SettingsViewModel *settings = new SettingsViewModel();
    PainEpisodesViewModel* episodesViewModel = new PainEpisodesViewModel();
    qmlRegisterSingletonInstance("PainAnalyzer",1,0,"PatientManager",patientManager);
    qmlRegisterSingletonInstance("PainAnalyzer",1,0,"Settings",settings);
    engine.rootContext()->setContextProperty("episodesViewModel", episodesViewModel);
    engine.loadFromModule("Patient","App");
    // Передаем данные в модель
    std::vector<PainEpisode> episodes(10);
    // episodes[0].intensity = 7;
    // episodes[0].started_at = "2026-06-14 16:36:26.562000 +00:00";
    // episodes[1].intensity = 2;
    // episodes[1].started_at = "2026-06-14 16:38:26.562000 +00:00";
    //
    // episodes[2].intensity = 5;
    // episodes[2].started_at = "2026-06-15 16:36:26.562000 +00:00";
    // episodes[3].intensity = 8;
    // episodes[3].triggers = {"Разговор","Ветер"};
    // episodes[3].symptoms = {"отек лица"};
    // episodes[3].types = {"жжет"};
    // episodes[3].auras = {"шаткость"};
    // episodes[4].started_at = "2026-06-12 16:38:26.562000 +00:00";
    // episodes[4].intensity = 1;
    // episodes[5].started_at = "2026-06-11 16:36:26.562000 +00:00";
    // episodes[5].intensity = 3;
    // episodes[6].started_at = "2026-06-10 16:36:26.562000 +00:00";
    // episodes[6].intensity = 7;
    // episodes[7].started_at = "2026-06-09 16:36:26.562000 +00:00";
    // episodes[7].intensity = 9;
    // episodes[8].started_at = "2026-06-08 16:36:26.562000 +00:00";
    // episodes[8].intensity = 9;
    // episodes[9].started_at = "2026-06-07 16:36:26.562000 +00:00";
    // episodes[9].intensity = 8;
    // episodesViewModel->listModel()->setEpisodes(episodes);
    // episodeModel->setEpisodes(episodes);
    if (engine.rootObjects().isEmpty()) {
        return -1;
    }
    return app.exec();
}