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

    signal userAdded(string username)

    function t(key) {
        return i18n ? i18n.t(key) : key;
    }

    function clearForm() {
        newUsernameField.text = "";
        newPasswordField.text = "";
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

    Layout.fillWidth: true
    Layout.fillHeight: true
    Layout.minimumHeight: 320
    radius: theme.dialogRadius
    color: theme.panel
    border.color: theme.borderLight
    border.width: 1

    AppTheme {
        id: theme
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 18
        spacing: 12

        Text {
            Layout.fillWidth: true
            text: root.t("login.test.title")
            color: theme.textPrimary
            font.pixelSize: 16
            font.bold: true
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
            Layout.preferredHeight: 132
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

                delegate: Rectangle {
                    id: optionDelegate

                    required property var modelData
                    required property int index

                    width: ListView.view.width
                    height: 34
                    radius: theme.radiusSmall
                    color: index % 2 === 0 ? theme.panel : "transparent"

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
    }
}
