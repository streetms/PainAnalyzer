#pragma once

#include <QTcpSocket>
#include <QJsonObject>

class NetworkManager : public QObject
{
    Q_OBJECT
public:
    explicit NetworkManager(QObject *parent = nullptr);
    static NetworkManager* instance();
    void connectToServer(const QString &host, quint16 port);
    void sendRequest(const QString &type, const QJsonObject &data);



private:
    QTcpSocket m_socket;
    QByteArray m_buffer;
};
