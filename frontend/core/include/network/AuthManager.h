#include <QNetworkReply>
#include "ApiClient.h"

class AuthManager : public QObject
{
    Q_OBJECT
public:
    QNetworkReply* login(QString email);
    void registerUser( nlohmann::json data);
    QNetworkReply* logout();
private:
    ApiClient api;
};
