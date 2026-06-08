//
// Created by konstantin on 08.06.2026.
//

#include "application/SettingsService.h"

SettingsService::SettingsService() {
    //_settings.setValue("triggers",{});
}

void SettingsService::setValue(QString key,QStringList value) {
    _settings.setValue(key,value);
}

QStringList SettingsService::getStringList(QString key) const{
    return _settings.value(key).toStringList();
}

