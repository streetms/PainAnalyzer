// Copyright (C) 2021 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR GPL-3.0-only

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickStyle>
#include <QQmlContext>
#include "record.h"

int main(int argc, char *argv[]) {
    Record record;
    QGuiApplication app(argc, argv);
    QQuickStyle::setStyle("Material");
    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("currentRecord", &record);
    const QUrl url("qrc:/qt/qml/PainAnalyzerContent/Screen01.qml");

    engine.load(QStringLiteral("qrc:/PainAnalyzer/PainAnalyzerContent/App.qml"));

    if (engine.rootObjects().isEmpty()) {
        return -1;
    }
    return app.exec();
}
