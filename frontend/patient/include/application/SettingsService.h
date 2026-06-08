//
// Created by konstantin on 08.06.2026.
//

#ifndef PAINANALYZER_SETTINGSSERVICE_H
#define PAINANALYZER_SETTINGSSERVICE_H
#include <QSettings>

class SettingsService {
    public:
    SettingsService();
    void setValue(QString key,QStringList value);

    QStringList getStringList(QString key) const;
private:
    QSettings _settings;
};


#endif //PAINANALYZER_SETTINGSSERVICE_H
