#include "network/NetworkManager.h"

#include <QJsonDocument>
#include <QJsonObject>
#include <QDebug>
#include <bits/ranges_base.h>
#include <nlohmann/json.hpp>

NetworkManager::NetworkManager(QObject *parent)
    : QObject(parent) {
    connectToServer("streetms.ru",5555);
}
NetworkManager * NetworkManager::instance() {
    static NetworkManager manager;
    return &manager;
}

void NetworkManager::connectToServer(const QString &host, quint16 port)
{
    m_socket.connectToHost(host, port);
}

void NetworkManager::sendRequest(const QString &type, nlohmann::json data)
{
    QByteArray json = data.dump().data();
    QByteArray packet;
    QDataStream stream(&packet, QIODevice::WriteOnly);
    stream.setByteOrder(QDataStream::BigEndian);
    stream << quint32(json.size());
    packet.append(json);
    m_socket.write(packet);
}
