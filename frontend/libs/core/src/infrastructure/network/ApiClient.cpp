#include "core/infrastructure/network/ApiClient.h"

#include <QJsonDocument>
#include <QJsonObject>
#include <QNetworkReply>
#include <nlohmann/json.hpp>
#include <QUrlQuery>
#include <QDebug>
ApiClient::ApiClient(QObject *parent)
    : QObject(parent) {
    baseUrl = "https://streetms.ru";
}


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

void ApiClient::get(const QString &type, nlohmann::json params, std::function<void(QNetworkReply *)> callback) {
    QUrl url(baseUrl + type);

    if (!params.is_null() && params.is_object()) {
        QUrlQuery query;
        for (auto& el : params.items()) {
            // Преобразуем значения JSON в строку для URL
            QString key = QString::fromStdString(el.key());
            QString value = QString::fromStdString(
                el.value().is_string() ? el.value().get<std::string>() : el.value().dump()
            );
            query.addQueryItem(key, value);
        }
        url.setQuery(query);
    }

    QNetworkRequest request(url);
    request.setRawHeader("Accept", "application/json");

    auto reply = manager.get(request);

    connect(reply, &QNetworkReply::finished, this, [reply, callback]() {
        callback(reply);
        reply->deleteLater();
    });
}
