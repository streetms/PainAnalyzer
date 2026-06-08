//
// Created by konstantin on 08.06.2026.
//

#ifndef PAINANALYZER_SETTINGSVIEWMODEL_H
#define PAINANALYZER_SETTINGSVIEWMODEL_H
#include <QObject>
#include "application/SettingsService.h"
class SettingsViewModel : public QObject
{
    Q_OBJECT

public:
    explicit SettingsViewModel(QObject *parent = nullptr);
public slots:
    QStringList userTriggers() const;
    QStringList userSymptoms() const;
    QStringList userAuras() const;
    QStringList userDrugs() const;
    QStringList userPainTypes() const;
    void updateTriggers(const QStringList& triggers);
    void updateAuras(const QStringList& auras);
    void updateSymptoms(const QStringList& symptoms);
    void updateDrugs(const QStringList& drugs);
    void updatePainTypes(const QStringList& painType);
    signals:
        void userTriggersChanged();

private:
    SettingsService _settingsService;
};

#endif //PAINANALYZER_SETTINGSVIEWMODEL_H
