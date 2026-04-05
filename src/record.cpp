//
// Created by konstantin on 05.04.2026.
//
#include <QDebug>
#include "record.h"

void Record::setTriggers(const QStringList& arr) {
    triggers = std::move(arr);
}

void Record::setSymptoms(const QStringList& arr) {
    symptoms = std::move(arr);
}
