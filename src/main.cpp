// Copyright (C) 2021 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR GPL-3.0-only

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickStyle>
#include <QQmlContext>


int main(int argc, char *argv[]) {
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;
    //QQmlContext *context = engine.rootContext();
    const QUrl url("qrc:/qt/qml/PainAnalyzerContent/App.qml");
    // QObject::connect(
    //         &engine, &QQmlApplicationEngine::objectCreated, &app,
    //         [url](QObject *obj, const QUrl &objUrl) {
    //             if (!obj && url == objUrl)
    //                 QCoreApplication::exit(-1);
    //         },
    //         Qt::QueuedConnection);

    engine.load(QStringLiteral("qrc:/PainAnalyzer/PainAnalyzerContent/App.qml"));

    if (engine.rootObjects().isEmpty()) {
        return -1;
    }
    return app.exec();
}
