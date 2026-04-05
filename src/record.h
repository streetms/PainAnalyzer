//
// Created by konstantin on 05.04.2026.
//

#ifndef PAINANALYZER_RECORD_H
#define PAINANALYZER_RECORD_H
#include <QObject>

class Record : public QObject {
    Q_OBJECT
private:
    QStringList triggers;
    QStringList symptoms;
public:

public slots:
    void setTriggers(const QStringList& arr);
    void setSymptoms(const QStringList& arr);
};




#endif //PAINANALYZER_RECORD_H
