#include <qfile.h>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "PatientManager.h"


int main(int argc, char *argv[]) {

    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;
    qDebug() << "mesh exists:"
         << QFile::exists(":/PainAnalyzer/assets/meshes/mesh0008_mesh.mesh");

    PatientManager *patientManager = new PatientManager();
    qmlRegisterSingletonInstance("PainAnalyzer",1,0,"PatientManager",patientManager);
    //const QUrl url("qrc:/qt/qml/PainAnalyzerContent/Screen01.qml");
    engine.loadFromModule("Patient","App");
    // engine.load(QStringLiteral("qrc:/qt/qml/Patient/App.qml"));

    if (engine.rootObjects().isEmpty()) {
        return -1;
    }
     return app.exec();
}