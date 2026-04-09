#pragma once
#include <QObject>

#include "models/User.h"

class UserManager : public QObject {
    Q_OBJECT
    Q_PROPERTY(bool isLoggedIn READ isLoggedIn NOTIFY isLoggedInChanged)

public:

    Q_INVOKABLE void login(const QString& phone, const QString& password);
    Q_INVOKABLE void logout();
    Q_INVOKABLE void updateProfile(const QString& name);

    bool isLoggedIn() const;
    // User* getUser() const { return user; }

    signals:
    void isLoggedInChanged();

private:
    bool m_loggedIn = false;
protected:
    User* _user = nullptr;
    // DbAuthRepository repo;
};
