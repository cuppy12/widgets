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
    Q_PROPERTY(QString storagePath READ storagePath CONSTANT)
    Q_PROPERTY(QString dataSource READ dataSource NOTIFY usersChanged)
    Q_PROPERTY(bool storageFileExists READ storageFileExists NOTIFY storageStateChanged)
    Q_PROPERTY(qint64 storageFileSize READ storageFileSize NOTIFY storageStateChanged)
    Q_PROPERTY(QString storageStateText READ storageStateText NOTIFY storageStateChanged)

public:
    explicit LoginBackend(QObject *parent = nullptr);

    QStringList users() const;
    QVariantList userRecords() const;
    QString storagePath() const;
    QString dataSource() const;
    bool storageFileExists() const;
    qint64 storageFileSize() const;
    QString storageStateText() const;

    Q_INVOKABLE QString validateLogin(const QString &username, const QString &password) const;
    Q_INVOKABLE QString addUser(const QString &username, const QString &password);
    Q_INVOKABLE QString deleteUser(const QString &username);
    Q_INVOKABLE int indexOfUser(const QString &username) const;
    Q_INVOKABLE bool reload();
    Q_INVOKABLE bool resetToDefaultUsers();
    Q_INVOKABLE bool saveNow();

signals:
    void usersChanged();
    void storageStateChanged();

private:
    struct User {
        QString username;
        QString password;
    };

    int findUserIndex(const QString &username) const;
    bool loadUsers();
    bool loadUsersFromJsonFile(const QString &filePath, QVector<User> *targetUsers) const;
    bool saveUsers(const QString &successMessage);
    bool setStorageError(const QString &message);
    QVector<User> fallbackUsers() const;
    QVector<User> normalizedUsers(const QVector<User> &users) const;
    QString resolveStoragePath() const;
    QString findProjectUsersJsonPath() const;
    QString defaultUsersResourcePath() const;

    QVector<User> m_users;
    QString m_storagePath;
    QString m_dataSource;
    QString m_storageStateText;
};
