#include "LoginBackend.h"

LoginBackend::LoginBackend(QObject *parent)
    : QObject(parent)
    , m_users({
          {"operator01", "123456"},
          {"operator02", "123456"},
          {"operator03", "123456"},
          {"engineer", "engineer123"},
          {"maintenance", "maintain123"},
          {"quality", "quality123"},
          {"shiftLead", "lead123"},
          {"admin", "admin123"},
          {"guest", "guest123"},
      })
{
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
    emit usersChanged();
    return "ok";
}

int LoginBackend::indexOfUser(const QString &username) const
{
    return findUserIndex(username.trimmed());
}

int LoginBackend::findUserIndex(const QString &username) const
{
    for (int i = 0; i < m_users.size(); ++i) {
        if (m_users.at(i).username.compare(username, Qt::CaseInsensitive) == 0)
            return i;
    }

    return -1;
}
