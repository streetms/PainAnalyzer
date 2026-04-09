//
// Created by konstantin on 06.04.2026.
//

#include "patient.h"


// Patient * Patient::instance() {
//     static Patient user;
//     return &user;
// }

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
