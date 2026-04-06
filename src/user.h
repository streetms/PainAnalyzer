//
// Created by konstantin on 06.04.2026.
//

#ifndef PAINANALYZER_USER_H
#define PAINANALYZER_USER_H
#include <QString>
#include <QDateTime>
#include "record.h"
class User : public QObject {
    Q_OBJECT
private:
    Record _record;
    QStringList _fullName;
    QDate _birthday;
    uint8_t _height;
    uint8_t _weight;
    enum class PainFrequency {
        never,
        rarely,
        sometimes,
        veryOften,
        constantly
    } _frequency;


public slots:
    void setFullName(const QStringList& arr);
    void setBirthday(const QDate& birthday);
    void setWeight(uint8_t weight);
    void setHeight(uint8_t height);

};

#endif //PAINANALYZER_USER_H
