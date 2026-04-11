#pragma once

#include <QTcpSocket>
#include <QJsonObject>
#include <nlohmann/json_fwd.hpp>

class NetworkManager : public QObject
{
    Q_OBJECT
public:
    explicit NetworkManager(QObject *parent = nullptr);
    static NetworkManager* instance();
    void connectToServer(const QString &host, quint16 port);
    void sendRequest(const QString &type, nlohmann::json json);



private:
    QTcpSocket m_socket;
    QByteArray m_buffer;
};
