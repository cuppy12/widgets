pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls.Basic as Basic
import QtQuick.Layouts
import "../components/controls"
import "../components/theme"

Rectangle {
    id: root

    property var backend
    property var i18n
    property string statusText: ""
    property string badgeText: ""
    property int contentMargin: 18
    property int minimumPanelHeight: 320

    signal userAdded(string username)
    signal userDeleted(string username)

    function t(key) {
        return i18n ? i18n.t(key) : key;
    }

    function clearForm() {
        newUsernameField.text = "";
        newPasswordField.text = "";
    }

    function dataSourceText() {
        if (!backend)
            return "";

        if (backend.dataSource === "local")
            return t("login.test.source.local");
        if (backend.dataSource === "resource")
            return t("login.test.source.resource");
        return t("login.test.source.fallback");
    }

    function storageStatusText() {
        if (!backend)
            return "";

        const state = backend.storageStateText;
        let stateText = t("login.test.storage.unknown");
        if (state.indexOf("saved:") === 0)
            stateText = t("login.test.storage.saved");
        else if (state.indexOf("deleted:") === 0)
            stateText = t("login.test.storage.deleted");
        else if (state.indexOf("reset:") === 0)
            stateText = t("login.test.storage.reset");
        else if (state.indexOf("initialized:") === 0)
            stateText = t("login.test.storage.initialized");
        else if (state.indexOf("loaded") === 0)
            stateText = t("login.test.storage.loaded");
        else if (state.indexOf("error:") === 0)
            stateText = t("login.test.storage.error");

        const existsText = backend.storageFileExists ? t("login.test.file.exists") : t("login.test.file.missing");
        return stateText + "  " + existsText + "  " + t("login.test.file.size") + backend.storageFileSize + " B";
    }

    function submitUser() {
        if (!backend)
            return;

        const result = backend.addUser(newUsernameField.text, newPasswordField.text);
        if (result !== "ok") {
            statusText = t("login.add.error." + result);
            return;
        }

        const username = newUsernameField.text.trim();
        statusText = t("login.test.added") + username;
        clearForm();
        userAdded(username);
    }

    function deleteUser(username) {
        if (!backend)
            return;

        const result = backend.deleteUser(username);
        if (result !== "ok") {
            statusText = t("login.delete.error." + result);
            return;
        }

        statusText = t("login.delete.done") + username;
        userDeleted(username);
    }

    function reloadUsers() {
        if (!backend)
            return;

        statusText = backend.reload() ? t("login.test.reloaded") : t("login.test.reloadFailed");
    }

    function resetUsers() {
        if (!backend)
            return;

        statusText = backend.resetToDefaultUsers() ? t("login.test.resetDone") : t("login.test.resetFailed");
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

            Text {
                Layout.fillWidth: true
                text: root.t("login.test.title")
                color: theme.textPrimary
                font.pixelSize: 17
                font.bold: true
                elide: Text.ElideRight
            }

            Rectangle {
                visible: root.badgeText.length > 0
                Layout.preferredHeight: 24
                Layout.minimumWidth: backendBadgeLabel.implicitWidth + 18
                radius: 12
                color: theme.primarySoft

                Text {
                    id: backendBadgeLabel
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
            text: root.t("login.test.desc")
            color: theme.textMuted
            font.pixelSize: 13
            lineHeight: 1.15
            wrapMode: Text.WordWrap
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: storageInfoLayout.implicitHeight + 20
            radius: theme.radiusMedium
            color: "#F8FAFC"
            border.color: theme.borderLight
            border.width: 1

            ColumnLayout {
                id: storageInfoLayout
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: 12
                anchors.rightMargin: 12
                spacing: 4

                Text {
                    Layout.fillWidth: true
                    text: root.dataSourceText()
                    color: theme.textPrimary
                    font.pixelSize: 12
                    font.bold: true
                    elide: Text.ElideRight
                }

                Text {
                    Layout.fillWidth: true
                    text: root.backend ? root.t("login.test.storagePath") + root.backend.storagePath : ""
                    color: theme.textMuted
                    font.pixelSize: 11
                    wrapMode: Text.WrapAnywhere
                    maximumLineCount: 2
                    elide: Text.ElideRight
                }

                Text {
                    Layout.fillWidth: true
                    text: root.storageStatusText()
                    color: theme.textMuted
                    font.pixelSize: 11
                    elide: Text.ElideRight
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 176
            radius: theme.radiusMedium
            color: theme.fieldIdle
            border.color: theme.borderLight
            border.width: 1
            clip: true

            ListView {
                id: userList
                anchors.fill: parent
                anchors.margins: 6
                clip: true
                model: root.backend ? root.backend.userRecords : []
                boundsBehavior: Flickable.StopAtBounds
                currentIndex: -1

                delegate: Rectangle {
                    id: optionDelegate

                    required property var modelData
                    required property int index

                    width: ListView.view.width
                    height: 40
                    radius: theme.radiusSmall
                    color: ListView.isCurrentItem ? theme.primarySoft : (index % 2 === 0 ? theme.panel : "transparent")
                    border.color: ListView.isCurrentItem ? "#BBD7FF" : "transparent"
                    border.width: 1

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: userList.currentIndex = optionDelegate.index
                    }

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 10
                        anchors.rightMargin: 10
                        spacing: 8

                        Text {
                            Layout.fillWidth: true
                            text: optionDelegate.modelData.username
                            color: theme.textPrimary
                            font.pixelSize: 13
                            font.bold: true
                            elide: Text.ElideRight
                        }

                        Text {
                            text: root.t("login.test.passwordPrefix") + optionDelegate.modelData.password
                            color: theme.textMuted
                            font.pixelSize: 12
                            elide: Text.ElideRight
                        }

                        AppButton {
                            text: root.t("login.delete.submit")
                            type: AppButton.Danger
                            minimumWidth: 54
                            horizontalPadding: 12
                            controlHeight: 28
                            onClicked: root.deleteUser(optionDelegate.modelData.username)
                        }
                    }
                }

                Text {
                    anchors.centerIn: parent
                    visible: userList.count === 0
                    text: root.t("login.test.empty")
                    color: theme.textPlaceholder
                    font.pixelSize: 13
                }

                footer: Rectangle {
                    width: userList.width
                    height: 28
                    color: "transparent"

                    Text {
                        anchors.left: parent.left
                        anchors.leftMargin: 8
                        anchors.verticalCenter: parent.verticalCenter
                        text: root.t("login.test.count") + userList.count
                        color: theme.textMuted
                        font.pixelSize: 11
                    }
                }

                Basic.ScrollBar.vertical: Basic.ScrollBar {
                    policy: userList.contentHeight > userList.height ? Basic.ScrollBar.AlwaysOn : Basic.ScrollBar.AsNeeded
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 8

            AppTextField {
                id: newUsernameField
                Layout.fillWidth: true
                label: root.t("login.add.username.label")
                placeholderText: root.t("login.add.username.placeholder")
            }

            AppTextField {
                id: newPasswordField
                Layout.fillWidth: true
                label: root.t("login.add.password.label")
                placeholderText: root.t("login.add.password.placeholder")
                passwordMode: true
                revealable: true
                onAccepted: root.submitUser()
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 8

            Text {
                Layout.fillWidth: true
                text: root.statusText.length > 0 ? root.statusText : root.t("login.test.hint")
                color: root.statusText.length > 0 ? theme.textSecondary : theme.textMuted
                font.pixelSize: 12
                elide: Text.ElideRight
            }

            AppButton {
                text: root.t("login.add.submit")
                type: AppButton.Primary
                minimumWidth: 88
                controlHeight: 32
                onClicked: root.submitUser()
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 8

            Item {
                Layout.fillWidth: true
            }

            AppButton {
                text: root.t("login.test.reload")
                minimumWidth: 82
                controlHeight: 30
                onClicked: root.reloadUsers()
            }

            AppButton {
                text: root.t("login.test.reset")
                minimumWidth: 104
                controlHeight: 30
                onClicked: root.resetUsers()
            }
        }
    }
}
