//
// Created by konstantin on 15.04.2026.
//

#include "network/AuthManager.h"
#include <nlohmann/json.hpp>
QNetworkReply * AuthManager::login(QString email) {
}

void AuthManager::registerUser( nlohmann::json data) {
    api.post("register", data,[](QNetworkReply* reply) {
        qDebug() << reply->readAll();
    });

}

QNetworkReply * AuthManager::logout() {
}
