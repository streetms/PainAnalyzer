#include <qfile.h>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickStyle>
#include "presentation/PatientManager.h"


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

    PatientManager *patientManager = new PatientManager();
    qmlRegisterSingletonInstance("PainAnalyzer",1,0,"PatientManager",patientManager);

    engine.loadFromModule("Patient","App");
    if (engine.rootObjects().isEmpty()) {
        return -1;
    }

     return app.exec();
}