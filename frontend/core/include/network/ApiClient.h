#pragma once

#include <QtNetwork/QNetworkAccessManager>
#include <nlohmann/json.hpp>

class ApiClient : public QObject
{
    Q_OBJECT
public:
    explicit ApiClient(QObject *parent = nullptr);
    static ApiClient* instance();
    void post(const QString &type, nlohmann::json data,std::function<void(QNetworkReply*)> callback);
private:
    QNetworkAccessManager manager;
    QString baseUrl;
};
