#include "network/ApiClient.h"

#include <QJsonDocument>
#include <QJsonObject>
#include <QNetworkReply>
#include <nlohmann/json.hpp>
#include <QDebug>
ApiClient::ApiClient(QObject *parent)
    : QObject(parent) {
    baseUrl = "http://streetms.ru:5555";
}
ApiClient * ApiClient::instance() {
    static ApiClient manager;
    return &manager;
}

void ApiClient::post(const QString &type, nlohmann::json data,std::function<void(QNetworkReply*)> callback) {
    QNetworkRequest request(QUrl("http://streetms.ru:5555/"+type));
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

// void ApiClient::registerUser(const QString& email, const QString& password)
// {
//     QJsonObject json;
//     json["email"] = email;
//     json["password"] = password;
//
//     QNetworkRequest request(QUrl("http://127.0.0.1:5555/register"));
//     request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
//
//     auto reply = manager.post(request, QJsonDocument(json).toJson());
//
//     connect(reply, &QNetworkReply::finished, this, [this, reply]()
//     {
//         emit registerFinished(reply->readAll());
//         reply->deleteLater();
//     });
// }
// void ApiClient::post(const QString &type, nlohmann::json data)
// {
//     nlohmann::json request;
//     request["data"] = data;
//     request["type"] = type.toStdString();
//
//     QByteArray json = request.dump().data();
//     QByteArray packet;
//     QDataStream stream(&packet, QIODevice::WriteOnly);
//     stream.setByteOrder(QDataStream::BigEndian);
//     stream << quint32(json.size());
//     packet.append(json);
//     // m_socket.write(packet);
// }
