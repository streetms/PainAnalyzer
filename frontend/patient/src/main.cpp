#include <qfile.h>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickStyle>
#include <QQmlContext>
#include "presentation/PatientViewModel.h"
#include "presentation/SettingsViewModel.h"
#include "presentation/PainEpisodeViewModel.h"


int main(int argc, char *argv[]) {
    qputenv("ANDROID_OPENSSL_SUFFIX", "_3");
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

    std::vector<PainEpisode> episodes(10);
    if (engine.rootObjects().isEmpty()) {
        return -1;
    }
    return app.exec();
}