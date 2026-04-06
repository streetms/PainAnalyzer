//
// Created by konstantin on 06.04.2026.
//

#include "user.h"

void User::setFullName(const QStringList &fullName) {
    _fullName = fullName;
}

void User::setBirthday(const QDate &birthday) {
    _birthday = birthday;
}

void User::setWeight(uint8_t weight) {
    _weight = weight;
}

void User::setHeight(uint8_t height) {
    _height = height;
}
