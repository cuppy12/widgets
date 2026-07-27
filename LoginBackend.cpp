#include "LoginBackend.h"

#include <QCoreApplication>
#include <QDir>
#include <QFile>
#include <QFileInfo>
#include <QLocale>
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonValue>
#include <QSaveFile>

LoginBackend::LoginBackend(QObject *parent)
    : QObject(parent)
{
    m_storagePath = resolveStoragePath();

    loadUsers();
}

QStringList LoginBackend::users() const
{
    QStringList result;
    result.reserve(m_users.size());
    for (const User &user : m_users)
        result.append(user.username);
    return result;
}

QVariantList LoginBackend::userRecords() const
{
    QVariantList result;
    result.reserve(m_users.size());
    for (const User &user : m_users) {
        result.append(QVariantMap {
            {"username", user.username},
            {"password", user.password},
        });
    }
    return result;
}

QString LoginBackend::storagePath() const
{
    return m_storagePath;
}

QString LoginBackend::dataSource() const
{
    return m_dataSource;
}

bool LoginBackend::storageFileExists() const
{
    return QFileInfo::exists(m_storagePath);
}

qint64 LoginBackend::storageFileSize() const
{
    const QFileInfo storageInfo(m_storagePath);
    return storageInfo.exists() ? storageInfo.size() : 0;
}

QString LoginBackend::storageStateText() const
{
    return m_storageStateText;
}

QString LoginBackend::validateLogin(const QString &username, const QString &password) const
{
    const QString normalizedUsername = username.trimmed();
    if (normalizedUsername.isEmpty() || password.isEmpty())
        return "empty";

    const int index = findUserIndex(normalizedUsername);
    if (index < 0)
        return "unknownUser";

    if (m_users.at(index).password != password)
        return "wrongPassword";

    return "ok";
}

QString LoginBackend::addUser(const QString &username, const QString &password)
{
    const QString normalizedUsername = username.trimmed();
    if (normalizedUsername.isEmpty() || password.isEmpty())
        return "empty";

    if (password.size() < 6)
        return "weakPassword";

    if (findUserIndex(normalizedUsername) >= 0)
        return "duplicate";

    m_users.append({normalizedUsername, password});
    if (!saveUsers(QStringLiteral("saved"))) {
        m_users.removeLast();
        return "saveFailed";
    }

    m_dataSource = "local";
    emit usersChanged();
    return "ok";
}

QString LoginBackend::deleteUser(const QString &username)
{
    const QString normalizedUsername = username.trimmed();
    if (normalizedUsername.isEmpty())
        return "empty";

    const int index = findUserIndex(normalizedUsername);
    if (index < 0)
        return "notFound";

    const User removedUser = m_users.at(index);
    m_users.removeAt(index);
    if (!saveUsers(QStringLiteral("deleted"))) {
        m_users.insert(index, removedUser);
        return "saveFailed";
    }

    m_dataSource = "local";
    emit usersChanged();
    return "ok";
}

int LoginBackend::indexOfUser(const QString &username) const
{
    return findUserIndex(username.trimmed());
}

bool LoginBackend::reload()
{
    const bool loaded = loadUsers();
    emit usersChanged();
    emit storageStateChanged();
    return loaded;
}

bool LoginBackend::resetToDefaultUsers()
{
    QVector<User> defaultUsers;
    if (!loadUsersFromJsonFile(defaultUsersResourcePath(), &defaultUsers))
        defaultUsers = fallbackUsers();

    m_users = normalizedUsers(defaultUsers);
    m_dataSource = "resource";

    const bool saved = saveUsers(QStringLiteral("reset"));
    if (saved)
        m_dataSource = "local";

    emit usersChanged();
    return saved;
}

bool LoginBackend::saveNow()
{
    const bool saved = saveUsers(QStringLiteral("saved"));
    if (saved)
        m_dataSource = "local";

    emit usersChanged();
    return saved;
}

int LoginBackend::findUserIndex(const QString &username) const
{
    for (int i = 0; i < m_users.size(); ++i) {
        if (m_users.at(i).username.compare(username, Qt::CaseInsensitive) == 0)
            return i;
    }

    return -1;
}

bool LoginBackend::loadUsers()
{
    QVector<User> loadedUsers;
    if (QFileInfo::exists(m_storagePath) && loadUsersFromJsonFile(m_storagePath, &loadedUsers)) {
        m_users = normalizedUsers(loadedUsers);
        m_dataSource = "local";
        m_storageStateText = QStringLiteral("loaded");
        return true;
    }

    if (loadUsersFromJsonFile(defaultUsersResourcePath(), &loadedUsers)) {
        m_users = normalizedUsers(loadedUsers);
        m_dataSource = "resource";
        saveUsers(QStringLiteral("initialized"));
        return true;
    }

    m_users = fallbackUsers();
    m_dataSource = "fallback";
    saveUsers(QStringLiteral("initialized"));
    return !m_users.isEmpty();
}

bool LoginBackend::loadUsersFromJsonFile(const QString &filePath, QVector<User> *targetUsers) const
{
    QFile file(filePath);
    if (!file.open(QIODevice::ReadOnly))
        return false;

    const QJsonDocument document = QJsonDocument::fromJson(file.readAll());
    if (document.isNull())
        return false;

    const QJsonValue usersValue = document.isArray()
        ? QJsonValue(document.array())
        : document.object().value("users");

    if (!usersValue.isArray())
        return false;

    QVector<User> parsedUsers;
    const QJsonArray usersArray = usersValue.toArray();
    parsedUsers.reserve(usersArray.size());

    for (const QJsonValue &value : usersArray) {
        const QJsonObject object = value.toObject();
        const QString username = object.value("username").toString().trimmed();
        const QString password = object.value("password").toString();
        if (username.isEmpty() || password.isEmpty())
            continue;

        parsedUsers.append({username, password});
    }

    if (parsedUsers.isEmpty())
        return false;

    *targetUsers = parsedUsers;
    return true;
}

bool LoginBackend::saveUsers(const QString &successMessage)
{
    const QFileInfo storageInfo(m_storagePath);
    QDir directory(storageInfo.absolutePath());
    if (!directory.exists() && !directory.mkpath("."))
        return setStorageError(QStringLiteral("mkdirFailed"));

    QJsonArray usersArray;
    for (const User &user : m_users) {
        QJsonObject object;
        object.insert("username", user.username);
        object.insert("password", user.password);
        usersArray.append(object);
    }

    QJsonObject rootObject;
    rootObject.insert("schemaVersion", 1);
    rootObject.insert("users", usersArray);

    QSaveFile file(m_storagePath);
    if (!file.open(QIODevice::WriteOnly | QIODevice::Truncate))
        return setStorageError(QStringLiteral("openFailed"));

    file.write(QJsonDocument(rootObject).toJson(QJsonDocument::Indented));
    if (!file.commit())
        return setStorageError(QStringLiteral("commitFailed"));

    const QFileInfo savedInfo(m_storagePath);
    m_storageStateText = QStringLiteral("%1:%2:%3")
                             .arg(successMessage,
                                  QString::number(savedInfo.size()),
                                  QLocale::c().toString(savedInfo.lastModified(), QStringLiteral("yyyy-MM-dd HH:mm:ss")));
    emit storageStateChanged();
    return true;
}

bool LoginBackend::setStorageError(const QString &message)
{
    m_storageStateText = QStringLiteral("error:%1").arg(message);
    emit storageStateChanged();
    return false;
}

QVector<LoginBackend::User> LoginBackend::fallbackUsers() const
{
    return {
        {"operator01", "123456"},
        {"operator02", "123456"},
        {"operator03", "123456"},
        {"engineer", "engineer123"},
        {"maintenance", "maintain123"},
        {"quality", "quality123"},
        {"shiftLead", "lead123"},
        {"admin", "admin123"},
        {"guest", "guest123"},
    };
}

QVector<LoginBackend::User> LoginBackend::normalizedUsers(const QVector<User> &users) const
{
    QVector<User> result;
    result.reserve(users.size());

    for (const User &user : users) {
        const QString username = user.username.trimmed();
        if (username.isEmpty() || user.password.isEmpty())
            continue;

        bool duplicate = false;
        for (const User &existingUser : result) {
            if (existingUser.username.compare(username, Qt::CaseInsensitive) == 0) {
                duplicate = true;
                break;
            }
        }

        if (!duplicate)
            result.append({username, user.password});
    }

    return result.isEmpty() ? fallbackUsers() : result;
}

QString LoginBackend::resolveStoragePath() const
{
    const QString projectUsersJsonPath = findProjectUsersJsonPath();
    if (!projectUsersJsonPath.isEmpty())
        return projectUsersJsonPath;

    return QDir(QCoreApplication::applicationDirPath()).filePath(QStringLiteral("login-users.json"));
}

QString LoginBackend::findProjectUsersJsonPath() const
{
    const QString relativeUsersPath = QStringLiteral("resources/login/users.json");
    const QStringList startPaths {
        QDir::currentPath(),
        QCoreApplication::applicationDirPath(),
    };

    for (const QString &startPath : startPaths) {
        QDir directory(startPath);
        while (true) {
            const QString candidatePath = directory.filePath(relativeUsersPath);
            const bool looksLikeProjectRoot = QFileInfo::exists(directory.filePath(QStringLiteral("CMakeLists.txt")))
                && QFileInfo::exists(directory.filePath(QStringLiteral("qml/Main.qml")));

            if (looksLikeProjectRoot && QFileInfo::exists(candidatePath))
                return QFileInfo(candidatePath).absoluteFilePath();

            if (!directory.cdUp())
                break;
        }
    }

    return {};
}

QString LoginBackend::defaultUsersResourcePath() const
{
    return QStringLiteral(":/qt/qml/widgets/resources/login/default-users.json");
}
