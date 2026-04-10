// // // Copyright (C) 2021 The Qt Company Ltd.
// // // SPDX-License-Identifier: LicenseRef-Qt-Commercial OR GPL-3.0-only
// //
// // #include <QGuiApplication>
// // #include <QQmlApplicationEngine>
// // #include <QQuickStyle>
// // #include <QQmlContext>
// //
// // #include "patient.h"
// // #include "PatientManager.h"
// //
// //
// // int main(int argc, char *argv[]) {
// //
// //     QGuiApplication app(argc, argv);
// //     QQmlApplicationEngine engine;
// //     auto patient = PatientManager::instance()->getPatient();
// //     qmlRegisterType<Patient>("PainAnalyzer", 1, 0, "Patient");
// //     qmlRegisterSingletonInstance("PainAnalyzer",1,0,"PatientManager",PatientManager::instance());
// //     engine.load(QStringLiteral("qrc:/patient/App.qml"));
// //
// //     if (engine.rootObjects().isEmpty()) {
// //         return -1;
// //     }
// //     return app.exec();
// // }
// // main.cpp
// #include <QCoreApplication>
// #include <QTcpSocket>
// #include <QDebug>
// #include "PatientManager.h"
// int main(int argc, char *argv[])
// {
//     QCoreApplication a(argc, argv);
//     auto p = PatientManager::instance();
//     p->upload();
//     qDebug() << "----";
//     // QTcpSocket socket;
//     //
//     // socket.connectToHost("94.250.253.177", 5555);
//     //
//     // if (socket.waitForConnected(3000)) {
//     //     qDebug() << "Connected to server";
//     //
//     //     QByteArray message = "Hello from Qt client";
//     //     socket.write(message);
//     //
//     //     if (socket.waitForBytesWritten(3000)) {
//     //         if (socket.waitForReadyRead(3000)) {
//     //             QByteArray response = socket.readAll();
//     //             qDebug() << "Server reply:" << response;
//     //         }
//     //     }
//     // } else {
//     //     qDebug() << "Connection failed";
//     // }
//
//     return 0;
// }

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