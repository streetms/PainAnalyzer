//
// Created by konstantin on 31.05.2026.
//

#include "infrastructure/PatientRepository.h"
#include <QNetworkReply>
#include <exception>
#include <iostream>
void PatientRepository::savePainEpisode(const PainEpisode &episode) {
    qDebug() << "saved";

    api.post("/savePainEpisode", episode,[](QNetworkReply* reply) {
        qDebug() << reply->readAll();
    });

}
