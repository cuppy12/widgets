#pragma once

#include <QObject>
#include <QString>
#include <QTimer>
#include <QVariantList>

class ProgressBackend : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int minimum READ minimum CONSTANT)
    Q_PROPERTY(int maximum READ maximum CONSTANT)
    Q_PROPERTY(int value READ value NOTIFY progressChanged)
    Q_PROPERTY(bool running READ running NOTIFY statusChanged)
    Q_PROPERTY(bool finished READ finished NOTIFY statusChanged)
    Q_PROPERTY(QString state READ state NOTIFY statusChanged)
    Q_PROPERTY(QString taskKey READ taskKey NOTIFY statusChanged)
    Q_PROPERTY(QString phaseKey READ phaseKey NOTIFY statusChanged)
    Q_PROPERTY(QString detailKey READ detailKey NOTIFY statusChanged)
    Q_PROPERTY(int stepIndex READ stepIndex NOTIFY statusChanged)
    Q_PROPERTY(int stepCount READ stepCount CONSTANT)
    Q_PROPERTY(QVariantList eventRecords READ eventRecords NOTIFY eventsChanged)

public:
    explicit ProgressBackend(QObject *parent = nullptr);

    int minimum() const;
    int maximum() const;
    int value() const;
    bool running() const;
    bool finished() const;
    QString state() const;
    QString taskKey() const;
    QString phaseKey() const;
    QString detailKey() const;
    int stepIndex() const;
    int stepCount() const;
    QVariantList eventRecords() const;

    Q_INVOKABLE QString startTask(const QString &taskType);
    Q_INVOKABLE QString cancelTask();
    Q_INVOKABLE QString failTask();
    Q_INVOKABLE void resetTask();

signals:
    void progressChanged();
    void statusChanged();
    void eventsChanged();

private:
    void advanceProgress();
    void finishTask();
    void appendEvent(const QString &messageKey);
    QString normalizedTaskType(const QString &taskType) const;
    QString taskKeyForType(const QString &taskType) const;
    QString phaseKeyForValue(int value) const;
    QString eventKeyForPhase(const QString &phaseKey) const;

    QTimer m_timer;
    QVariantList m_events;
    int m_value = 0;
    int m_tick = 0;
    bool m_running = false;
    bool m_finished = false;
    QString m_state = QStringLiteral("idle");
    QString m_taskType = QStringLiteral("batch");
    QString m_taskKey = QStringLiteral("progress.task.none");
    QString m_phaseKey = QStringLiteral("progress.phase.idle");
    QString m_detailKey = QStringLiteral("progress.detail.idle");
};
