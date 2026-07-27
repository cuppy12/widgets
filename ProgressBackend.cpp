#include "ProgressBackend.h"

#include <QDateTime>
#include <QVariantMap>

ProgressBackend::ProgressBackend(QObject *parent)
    : QObject(parent)
{
    m_timer.setInterval(360);
    connect(&m_timer, &QTimer::timeout, this, &ProgressBackend::advanceProgress);
}

int ProgressBackend::minimum() const
{
    return 0;
}

int ProgressBackend::maximum() const
{
    return 100;
}

int ProgressBackend::value() const
{
    return m_value;
}

bool ProgressBackend::running() const
{
    return m_running;
}

bool ProgressBackend::finished() const
{
    return m_finished;
}

QString ProgressBackend::state() const
{
    return m_state;
}

QString ProgressBackend::taskKey() const
{
    return m_taskKey;
}

QString ProgressBackend::phaseKey() const
{
    return m_phaseKey;
}

QString ProgressBackend::detailKey() const
{
    return m_detailKey;
}

int ProgressBackend::stepIndex() const
{
    return qMin(5, qMax(0, m_value / 20));
}

int ProgressBackend::stepCount() const
{
    return 5;
}

QVariantList ProgressBackend::eventRecords() const
{
    return m_events;
}

QString ProgressBackend::startTask(const QString &taskType)
{
    if (m_running)
        return QStringLiteral("running");

    m_taskType = normalizedTaskType(taskType);
    m_taskKey = taskKeyForType(m_taskType);
    m_value = 0;
    m_tick = 0;
    m_running = true;
    m_finished = false;
    m_state = QStringLiteral("running");
    m_phaseKey = QStringLiteral("progress.phase.prepare");
    m_detailKey = QStringLiteral("progress.detail.running");
    m_events.clear();

    appendEvent(QStringLiteral("progress.event.started"));
    emit progressChanged();
    emit statusChanged();

    m_timer.start();
    return QStringLiteral("ok");
}

QString ProgressBackend::cancelTask()
{
    if (!m_running)
        return QStringLiteral("notRunning");

    m_timer.stop();
    m_running = false;
    m_finished = false;
    m_state = QStringLiteral("cancelled");
    m_phaseKey = QStringLiteral("progress.phase.cancelled");
    m_detailKey = QStringLiteral("progress.detail.cancelled");

    appendEvent(QStringLiteral("progress.event.cancelled"));
    emit statusChanged();
    return QStringLiteral("ok");
}

QString ProgressBackend::failTask()
{
    if (!m_running)
        return QStringLiteral("notRunning");

    m_timer.stop();
    m_running = false;
    m_finished = false;
    m_state = QStringLiteral("error");
    m_phaseKey = QStringLiteral("progress.phase.error");
    m_detailKey = QStringLiteral("progress.detail.error");

    appendEvent(QStringLiteral("progress.event.error"));
    emit statusChanged();
    return QStringLiteral("ok");
}

void ProgressBackend::resetTask()
{
    m_timer.stop();
    m_events.clear();
    m_value = 0;
    m_tick = 0;
    m_running = false;
    m_finished = false;
    m_state = QStringLiteral("idle");
    m_taskKey = QStringLiteral("progress.task.none");
    m_phaseKey = QStringLiteral("progress.phase.idle");
    m_detailKey = QStringLiteral("progress.detail.idle");

    emit progressChanged();
    emit statusChanged();
    emit eventsChanged();
}

void ProgressBackend::advanceProgress()
{
    if (!m_running)
        return;

    ++m_tick;
    const int delta = 4 + (m_tick % 3) * 3;
    m_value = qMin(maximum(), m_value + delta);

    const QString nextPhaseKey = phaseKeyForValue(m_value);
    if (nextPhaseKey != m_phaseKey) {
        m_phaseKey = nextPhaseKey;
        appendEvent(eventKeyForPhase(nextPhaseKey));
    }

    emit progressChanged();
    emit statusChanged();

    if (m_value >= maximum())
        finishTask();
}

void ProgressBackend::finishTask()
{
    m_timer.stop();
    m_value = maximum();
    m_running = false;
    m_finished = true;
    m_state = QStringLiteral("completed");
    m_phaseKey = QStringLiteral("progress.phase.done");
    m_detailKey = QStringLiteral("progress.detail.completed");

    appendEvent(QStringLiteral("progress.event.completed"));
    emit progressChanged();
    emit statusChanged();
}

void ProgressBackend::appendEvent(const QString &messageKey)
{
    QVariantMap event;
    event.insert(QStringLiteral("time"), QDateTime::currentDateTime().toString(QStringLiteral("HH:mm:ss")));
    event.insert(QStringLiteral("state"), m_state);
    event.insert(QStringLiteral("value"), m_value);
    event.insert(QStringLiteral("messageKey"), messageKey);

    m_events.prepend(event);
    while (m_events.size() > 6)
        m_events.removeLast();

    emit eventsChanged();
}

QString ProgressBackend::normalizedTaskType(const QString &taskType) const
{
    const QString normalized = taskType.trimmed().toLower();
    if (normalized == QStringLiteral("upload") || normalized == QStringLiteral("download") || normalized == QStringLiteral("batch"))
        return normalized;

    return QStringLiteral("batch");
}

QString ProgressBackend::taskKeyForType(const QString &taskType) const
{
    if (taskType == QStringLiteral("upload"))
        return QStringLiteral("progress.task.upload");
    if (taskType == QStringLiteral("download"))
        return QStringLiteral("progress.task.download");

    return QStringLiteral("progress.task.batch");
}

QString ProgressBackend::phaseKeyForValue(int value) const
{
    if (value < 15)
        return QStringLiteral("progress.phase.prepare");
    if (value < 45)
        return QStringLiteral("progress.phase.transfer");
    if (value < 75)
        return QStringLiteral("progress.phase.process");
    if (value < 95)
        return QStringLiteral("progress.phase.verify");

    return QStringLiteral("progress.phase.finish");
}

QString ProgressBackend::eventKeyForPhase(const QString &phaseKey) const
{
    if (phaseKey == QStringLiteral("progress.phase.transfer"))
        return QStringLiteral("progress.event.transfer");
    if (phaseKey == QStringLiteral("progress.phase.process"))
        return QStringLiteral("progress.event.process");
    if (phaseKey == QStringLiteral("progress.phase.verify"))
        return QStringLiteral("progress.event.verify");
    if (phaseKey == QStringLiteral("progress.phase.finish"))
        return QStringLiteral("progress.event.finish");

    return QStringLiteral("progress.event.updated");
}
