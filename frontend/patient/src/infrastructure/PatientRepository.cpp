//
// Created by konstantin on 31.05.2026.
//

#include "infrastructure/PatientRepository.h"
#include <iostream>
void PatientRepository::savePainEpisode(const PainEpisode &episode) {
    std::cout << "saved" << std::endl;
    // api.post("/savePainEpisode", episode,[](QNetworkReply* reply) {
    // });
    //     api.post("/register", data,[](QNetworkReply* reply) {
    //         qDebug() << reply->readAll();
    //     });
}
