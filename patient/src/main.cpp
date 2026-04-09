// Copyright (C) 2021 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR GPL-3.0-only

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickStyle>
#include <QQmlContext>

#include "patient.h"
#include "PatientManager.h"


int main(int argc, char *argv[]) {

    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;
    auto patient = PatientManager::instance()->getPatient();
    qmlRegisterType<Patient>("PainAnalyzer", 1, 0, "Patient");
    qmlRegisterSingletonInstance("PainAnalyzer",1,0,"PatientManager",PatientManager::instance());
    const QUrl url("qrc:/qt/qml/PainAnalyzerContent/Screen01.qml");

    engine.load(QStringLiteral("qrc:/patient/App.qml"));

    if (engine.rootObjects().isEmpty()) {
        return -1;
    }
    return app.exec();
}
