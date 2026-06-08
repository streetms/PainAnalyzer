#include <qfile.h>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickStyle>
#include "presentation/PatientViewModel.h"
#include "presentation/SettingsViewModel.h"

int factorial(int number) {
    int res = 1;
    for (int i = 1; i <= number; i++) {
        res *= i;
    }
    return res;
}


int main(int argc, char *argv[]) {

    QGuiApplication app(argc, argv);

    QQuickStyle::setStyle("Material");

    QQmlApplicationEngine engine;

    PatientViewModel *patientManager = new PatientViewModel();
    SettingsViewModel *settings = new SettingsViewModel();
    qmlRegisterSingletonInstance("PainAnalyzer",1,0,"PatientManager",patientManager);
    qmlRegisterSingletonInstance("PainAnalyzer",1,0,"Settings",settings);

    engine.loadFromModule("Patient","App");
    if (engine.rootObjects().isEmpty()) {
        return -1;
    }
    qDebug() << "-------------------------------------------------";
    qDebug() << QSslSocket::availableBackends();
    qDebug() << QSslSocket::supportsSsl();
    qDebug() << "-------------------------------------------------";
     return app.exec();
}