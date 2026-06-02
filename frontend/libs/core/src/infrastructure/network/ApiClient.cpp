#include "core/infrastructure/network/ApiClient.h"

#include <QJsonDocument>
#include <QJsonObject>
#include <QNetworkReply>
#include <nlohmann/json.hpp>
#include <QDebug>
ApiClient::ApiClient(QObject *parent)
    : QObject(parent) {
    baseUrl = "https://streetms.ru";
}
// ApiClient * ApiClient::instance() {
//     static ApiClient manager;
//     return &manager;
// }

void ApiClient::post(const QString &type, nlohmann::json data,std::function<void(QNetworkReply*)> callback) {
    QNetworkRequest request(QUrl(baseUrl+type));
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    QByteArray json = data.dump().data();
    QByteArray packet;
    QDataStream stream(&packet, QIODevice::WriteOnly);
    stream.setByteOrder(QDataStream::BigEndian);
    packet.append(json);

    auto reply = manager.post(request,packet);
    connect(reply, &QNetworkReply::finished, this, [reply, callback]() {
        callback(reply);
        reply->deleteLater();
    });
}
