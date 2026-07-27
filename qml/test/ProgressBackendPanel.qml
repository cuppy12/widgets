pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import "../components/controls"
import "../components/theme"

Rectangle {
    id: root

    property var backend
    property var i18n
    property string badgeText: ""
    property string statusText: ""
    property int contentMargin: 18
    property int minimumPanelHeight: 320

    function t(key) {
        return i18n ? i18n.t(key) : key;
    }

    function startTask(taskType) {
        if (!backend)
            return;

        const result = backend.startTask(taskType);
        statusText = result === "ok" ? t("progress.test.started") : t("progress.test.error." + result);
    }

    function cancelTask() {
        if (!backend)
            return;

        const result = backend.cancelTask();
        statusText = result === "ok" ? t("progress.test.cancelled") : t("progress.test.error." + result);
    }

    function failTask() {
        if (!backend)
            return;

        const result = backend.failTask();
        statusText = result === "ok" ? t("progress.test.failed") : t("progress.test.error." + result);
    }

    function resetTask() {
        if (!backend)
            return;

        backend.resetTask();
        statusText = t("progress.test.resetDone");
    }

    function stateColor() {
        if (!backend)
            return theme.textMuted;
        if (backend.state === "completed")
            return theme.success;
        if (backend.state === "cancelled")
            return theme.warning;
        if (backend.state === "error")
            return theme.danger;
        if (backend.state === "running")
            return theme.primary;

        return theme.textMuted;
    }

    Layout.fillWidth: true
    Layout.minimumHeight: minimumPanelHeight
    implicitHeight: Math.max(minimumPanelHeight, panelLayout.implicitHeight + contentMargin * 2)
    radius: theme.dialogRadius
    color: theme.panel
    border.color: theme.borderLight
    border.width: 1

    AppTheme {
        id: theme
    }

    ColumnLayout {
        id: panelLayout
        anchors.fill: parent
        anchors.margins: root.contentMargin
        spacing: 12

        RowLayout {
            Layout.fillWidth: true
            spacing: 10

            Text {
                Layout.fillWidth: true
                text: root.t("progress.test.title")
                color: theme.textPrimary
                font.pixelSize: 17
                font.bold: true
                elide: Text.ElideRight
            }

            Rectangle {
                visible: root.badgeText.length > 0
                Layout.preferredHeight: 24
                Layout.minimumWidth: progressBadgeLabel.implicitWidth + 18
                radius: 12
                color: theme.primarySoft

                Text {
                    id: progressBadgeLabel
                    anchors.centerIn: parent
                    text: root.badgeText
                    color: theme.primaryPressed
                    font.pixelSize: 12
                    font.bold: true
                }
            }
        }

        Text {
            Layout.fillWidth: true
            text: root.t("progress.test.desc")
            color: theme.textMuted
            font.pixelSize: 13
            lineHeight: 1.18
            wrapMode: Text.WordWrap
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: backendStateLayout.implicitHeight + 22
            radius: theme.radiusMedium
            color: "#F8FAFC"
            border.color: theme.borderLight
            border.width: 1

            ColumnLayout {
                id: backendStateLayout
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: 12
                anchors.rightMargin: 12
                spacing: 7

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 10

                    Text {
                        Layout.fillWidth: true
                        text: root.backend ? root.t(root.backend.taskKey) : root.t("progress.task.none")
                        color: theme.textPrimary
                        font.pixelSize: 13
                        font.bold: true
                        elide: Text.ElideRight
                    }

                    Text {
                        text: root.backend ? root.t("progress.percent.prefix") + root.backend.value + "%" : "0%"
                        color: root.stateColor()
                        font.pixelSize: 13
                        font.bold: true
                    }
                }

                AppProgressBar {
                    Layout.fillWidth: true
                    minimum: root.backend ? root.backend.minimum : 0
                    maximum: root.backend ? root.backend.maximum : 100
                    value: root.backend ? root.backend.value : 0
                    label: root.t("progress.current")
                    status: root.backend && root.backend.state === "completed"
                            ? AppProgressBar.Success
                            : (root.backend && root.backend.state === "cancelled"
                               ? AppProgressBar.Warning
                               : (root.backend && root.backend.state === "error" ? AppProgressBar.Error : AppProgressBar.Normal))
                    striped: root.backend ? root.backend.running : false
                    barHeight: 8
                }

                Text {
                    Layout.fillWidth: true
                    text: root.backend ? root.t(root.backend.phaseKey) + "  " + root.t("progress.step.prefix") + root.backend.stepIndex + "/" + root.backend.stepCount : ""
                    color: theme.textMuted
                    font.pixelSize: 12
                    elide: Text.ElideRight
                }
            }
        }

        GridLayout {
            Layout.fillWidth: true
            columns: width < 500 ? 2 : 3
            columnSpacing: 8
            rowSpacing: 8

            AppButton {
                Layout.fillWidth: true
                text: root.t("progress.test.upload")
                type: AppButton.Primary
                enabled: !root.backend || !root.backend.running
                onClicked: root.startTask("upload")
            }

            AppButton {
                Layout.fillWidth: true
                text: root.t("progress.test.download")
                type: AppButton.Primary
                enabled: !root.backend || !root.backend.running
                onClicked: root.startTask("download")
            }

            AppButton {
                Layout.fillWidth: true
                text: root.t("progress.test.batch")
                type: AppButton.Primary
                enabled: !root.backend || !root.backend.running
                onClicked: root.startTask("batch")
            }

            AppButton {
                Layout.fillWidth: true
                text: root.t("progress.test.cancel")
                type: AppButton.Danger
                enabled: root.backend ? root.backend.running : false
                onClicked: root.cancelTask()
            }

            AppButton {
                Layout.fillWidth: true
                text: root.t("progress.test.fail")
                type: AppButton.Danger
                enabled: root.backend ? root.backend.running : false
                onClicked: root.failTask()
            }

            AppButton {
                Layout.fillWidth: true
                text: root.t("progress.test.reset")
                enabled: root.backend ? !root.backend.running : true
                onClicked: root.resetTask()
            }
        }

        Text {
            Layout.fillWidth: true
            visible: root.statusText.length > 0
            text: root.statusText
            color: theme.textSecondary
            font.pixelSize: 12
            elide: Text.ElideRight
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 8

            Text {
                Layout.fillWidth: true
                text: root.t("progress.test.events")
                color: theme.textPrimary
                font.pixelSize: 13
                font.bold: true
            }

            Repeater {
                model: root.backend ? root.backend.eventRecords : []

                delegate: Rectangle {
                    id: eventDelegate

                    required property var modelData

                    Layout.fillWidth: true
                    Layout.preferredHeight: 34
                    radius: theme.radiusSmall
                    color: theme.fieldIdle
                    border.color: theme.borderLight
                    border.width: 1

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 10
                        anchors.rightMargin: 10
                        spacing: 8

                        Text {
                            text: eventDelegate.modelData.time
                            color: theme.textMuted
                            font.pixelSize: 11
                        }

                        Text {
                            Layout.fillWidth: true
                            text: root.t(eventDelegate.modelData.messageKey)
                            color: theme.textSecondary
                            font.pixelSize: 12
                            elide: Text.ElideRight
                        }

                        Text {
                            text: eventDelegate.modelData.value + "%"
                            color: theme.textMuted
                            font.pixelSize: 11
                        }
                    }
                }
            }

            Text {
                Layout.fillWidth: true
                visible: !root.backend || root.backend.eventRecords.length === 0
                text: root.t("progress.test.noEvents")
                color: theme.textPlaceholder
                font.pixelSize: 12
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }
}
