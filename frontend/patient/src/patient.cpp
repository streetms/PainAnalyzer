//
// Created by konstantin on 06.04.2026.
//

#include "patient.h"

#include <QJsonObject>
#include <optional>
#include <QString>

QJsonObject Patient::toJson() const {

    return {
        {"fullname",_fullName.value()},
        {"birthday",_birthday.value().toString()},
        {"height",_height.value()},
        {"phone",_phone.value()},
        {"weight",_weight.value()}
    };
}

void Patient::setFullName(const QString &fullName) {
    _fullName = fullName;
}

void Patient::setBirthday(const QDate &birthday) {
    _birthday = birthday;
}

void Patient::setWeight(int weight) {
    _weight = weight;
}

void Patient::setHeight(int height) {
    _height = height;
}

void Patient::setPhone(const QString &phone) {
    _phone = phone;
}
