//
// Created by konstantin on 08.06.2026.
//

#include "presentation/SettingsViewModel.h"

SettingsViewModel::SettingsViewModel(QObject *parent) {
}

QStringList SettingsViewModel::userTriggers() const {
    return _settingsService.getStringList("triggers");
}

QStringList SettingsViewModel::userSymptoms() const {
    return _settingsService.getStringList("symptoms");
}

QStringList SettingsViewModel::userAuras() const {
    return _settingsService.getStringList("auras");
}

QStringList SettingsViewModel::userDrugs() const {
    return _settingsService.getStringList("drugs");
}

QStringList SettingsViewModel::userPainTypes() const {
    return _settingsService.getStringList("painTypes");
}

void SettingsViewModel::updateTriggers(const QStringList &triggers) {
    _settingsService.setValue("triggers", triggers);
}

void SettingsViewModel::updateAuras(const QStringList &auras) {
    _settingsService.setValue("auras", auras);
}

void SettingsViewModel::updateSymptoms(const QStringList& symptoms) {
    _settingsService.setValue("symptoms", symptoms);
}

void SettingsViewModel::updateDrugs(const QStringList &drugs) {
    _settingsService.setValue("drugs", drugs);
}

void SettingsViewModel::updatePainTypes(const QStringList &painTypes) {
    _settingsService.setValue("painTypes", painTypes);
}

//
// void SettingsViewModel::updateTriggers(const QStringList& triggers) {
//     _settingsService.updateTriggers(triggers);
// }
//
// void SettingsViewModel::updateAuras(const QStringList &auras) {
// }

