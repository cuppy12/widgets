#pragma once

#include <QObject>
#include <QStringList>
#include <QVariantList>
#include <QVariantMap>
#include <QVector>

class LoginBackend : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QStringList users READ users NOTIFY usersChanged)
    Q_PROPERTY(QVariantList userRecords READ userRecords NOTIFY usersChanged)

public:
    explicit LoginBackend(QObject *parent = nullptr);

    QStringList users() const;
    QVariantList userRecords() const;

    Q_INVOKABLE QString validateLogin(const QString &username, const QString &password) const;
    Q_INVOKABLE QString addUser(const QString &username, const QString &password);
    Q_INVOKABLE int indexOfUser(const QString &username) const;

signals:
    void usersChanged();

private:
    struct User {
        QString username;
        QString password;
    };

    int findUserIndex(const QString &username) const;

    QVector<User> m_users;
};
