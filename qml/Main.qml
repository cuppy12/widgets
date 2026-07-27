import QtQuick
import QtQuick.Controls.Basic as Basic
import QtQuick.Layouts
import "components"
import "components/controls"
import "components/theme"
import "test"

Basic.ApplicationWindow {
    id: window

    width: 760
    height: 600
    visible: true
    title: i18n.t("app.title")

    property string commonStatusKey: "status.common.initial"
    property string loginStatusKey: "status.login.initial"
    property string loadingStatusKey: "status.loading.initial"
    property string loginStatusUser: ""
    property string loginAddedUser: ""
    property bool loginStatusRemember: false
    property real progressValue: 38
    property var loginBackend: LoginBackend

    readonly property string commonStatus: i18n.t(commonStatusKey)
    readonly property string loadingStatus: i18n.t(loadingStatusKey)
    readonly property string loginStatus: loginStatusKey === "status.login.submitted"
                                           ? i18n.t("status.login.submitted") + loginStatusUser + (loginStatusRemember ? i18n.t("status.login.remember") : "")
                                           : (loginStatusKey === "status.login.userAdded"
                                              ? i18n.t("status.login.userAdded") + loginAddedUser
                                              : i18n.t(loginStatusKey))

    AppTheme {
        id: theme
    }

    AppI18n {
        id: i18n
    }

    Rectangle {
        anchors.fill: parent
        color: theme.page
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 24
        spacing: 18

        RowLayout {
            Layout.fillWidth: true
            spacing: 12

            Text {
                Layout.fillWidth: true
                text: i18n.t("page.title")
                color: theme.textPrimary
                font.pixelSize: 20
                font.bold: true
            }

            LanguageSwitch {
                currentLanguage: i18n.language
                languages: i18n.languageOptions
                label: i18n.t("language.label")
                onLanguageSelected: function(language) {
                    i18n.setLanguage(language);
                }
            }
        }

        Flickable {
            Layout.fillWidth: true
            Layout.fillHeight: true
            contentWidth: width
            contentHeight: componentGrid.implicitHeight
            clip: true
            boundsBehavior: Flickable.StopAtBounds

            Basic.ScrollBar.vertical: Basic.ScrollBar {
                policy: componentGrid.implicitHeight > parent.height ? Basic.ScrollBar.AlwaysOn : Basic.ScrollBar.AsNeeded
            }

            GridLayout {
                id: componentGrid
                width: parent.width
                columns: window.width < 620 ? 1 : (window.width < 980 ? 2 : 3)
                columnSpacing: 16
                rowSpacing: 16

                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.minimumHeight: 180
                    radius: theme.dialogRadius
                    color: theme.panel
                    border.color: theme.borderLight
                    border.width: 1

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 18
                    spacing: 12

                    Text {
                        Layout.fillWidth: true
                        text: i18n.t("card.common.title")
                        color: theme.textPrimary
                        font.pixelSize: 16
                        font.bold: true
                    }

                    Text {
                        Layout.fillWidth: true
                        text: i18n.t("card.common.desc")
                        color: theme.textMuted
                        font.pixelSize: 13
                        wrapMode: Text.WordWrap
                    }

                    Item { Layout.fillHeight: true }

                    Text {
                        Layout.fillWidth: true
                        text: i18n.t("status.prefix") + window.commonStatus
                        color: "#374151"
                        font.pixelSize: 13
                        elide: Text.ElideRight
                    }

                    AppButton {
                        text: i18n.t("card.common.open")
                        type: AppButton.Primary
                        minimumWidth: 112
                        controlHeight: 34
                        onClicked: commonDialog.open()
                    }
                }
                }

                Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.minimumHeight: 180
                radius: theme.dialogRadius
                color: theme.panel
                border.color: theme.borderLight
                border.width: 1

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 18
                    spacing: 12

                    Text {
                        Layout.fillWidth: true
                        text: i18n.t("card.login.title")
                        color: theme.textPrimary
                        font.pixelSize: 16
                        font.bold: true
                    }

                    Text {
                        Layout.fillWidth: true
                        text: i18n.t("card.login.desc")
                        color: theme.textMuted
                        font.pixelSize: 13
                        wrapMode: Text.WordWrap
                    }

                    Item { Layout.fillHeight: true }

                    Text {
                        Layout.fillWidth: true
                        text: i18n.t("status.prefix") + window.loginStatus
                        color: "#374151"
                        font.pixelSize: 13
                        elide: Text.ElideRight
                    }

                    AppButton {
                        text: i18n.t("card.login.open")
                        type: AppButton.Primary
                        minimumWidth: 112
                        controlHeight: 34
                        onClicked: {
                            loginDialog.errorText = "";
                            loginDialog.open();
                        }
                    }
                }
                }

                Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.minimumHeight: 180
                radius: theme.dialogRadius
                color: theme.panel
                border.color: theme.borderLight
                border.width: 1

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 18
                    spacing: 12

                    Text {
                        Layout.fillWidth: true
                        text: i18n.t("card.loading.title")
                        color: theme.textPrimary
                        font.pixelSize: 16
                        font.bold: true
                    }

                    Text {
                        Layout.fillWidth: true
                        text: i18n.t("card.loading.desc")
                        color: theme.textMuted
                        font.pixelSize: 13
                        wrapMode: Text.WordWrap
                    }

                    Item { Layout.fillHeight: true }

                    Text {
                        Layout.fillWidth: true
                        text: i18n.t("status.prefix") + window.loadingStatus
                        color: "#374151"
                        font.pixelSize: 13
                        elide: Text.ElideRight
                    }

                    AppButton {
                        text: i18n.t("card.loading.open")
                        type: AppButton.Primary
                        minimumWidth: 112
                        controlHeight: 34
                        onClicked: {
                            loadingDialog.progress = -1;
                            window.loadingStatusKey = "status.loading.running";
                            loadingDialog.open();
                            loadingCloseTimer.restart();
                        }
                    }
                }
                }

                Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.minimumHeight: 180
                radius: theme.dialogRadius
                color: theme.panel
                border.color: theme.borderLight
                border.width: 1

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 18
                    spacing: 12

                    Text {
                        Layout.fillWidth: true
                        text: i18n.t("card.progress.title")
                        color: theme.textPrimary
                        font.pixelSize: 16
                        font.bold: true
                    }

                    Text {
                        Layout.fillWidth: true
                        text: i18n.t("card.progress.desc")
                        color: theme.textMuted
                        font.pixelSize: 13
                        wrapMode: Text.WordWrap
                    }



                    Item { Layout.fillHeight: true }

                    AppButton {
                        text: i18n.t("card.progress.advance")
                        type: AppButton.Primary
                        minimumWidth: 112
                        controlHeight: 34
                        onClicked: {
                            window.progressValue = 0;
                            progressDialog.open();
                            progressDialogTimer.restart();
                        }
                    }
                }
                }
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.minimumHeight: 300
                    radius: theme.dialogRadius
                    color: theme.panel
                    border.color: theme.borderLight
                    border.width: 1

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 18
                        spacing: 12

                        Text {
                            Layout.fillWidth: true
                            text: i18n.t("card.message.title")
                            color: theme.textPrimary
                            font.pixelSize: 16
                            font.bold: true
                        }

                        Text {
                            Layout.fillWidth: true
                            text: i18n.t("card.message.desc")
                            color: theme.textMuted
                            font.pixelSize: 13
                            wrapMode: Text.WordWrap
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 8

                            AppMessage {
                                Layout.fillWidth: true
                                type: AppMessage.Normal
                                title: i18n.t("message.normal.title")
                                message: i18n.t("message.normal.text")
                            }

                            AppMessage {
                                Layout.fillWidth: true
                                type: AppMessage.Warning
                                title: i18n.t("message.warning.title")
                                message: i18n.t("message.warning.text")
                            }

                            AppMessage {
                                Layout.fillWidth: true
                                type: AppMessage.Error
                                title: i18n.t("message.error.title")
                                message: i18n.t("message.error.text")
                            }
                        }
                    }
                }

                LoginBackendPanel {
                    backend: window.loginBackend
                    i18n: i18n
                    onUserAdded: function(username) {
                        window.loginAddedUser = username;
                        window.loginStatusKey = "status.login.userAdded";
                        Qt.callLater(function() {
                            loginDialog.selectUser(username);
                        });
                    }
                }
            }
        }
    }

    CommonDialog {
        id: commonDialog
        dialogTitle: i18n.t("common.dialog.title")
        message: i18n.t("common.dialog.message")
        confirmText: i18n.t("common.confirm")
        cancelText: i18n.t("common.cancel")
        preferredWidth: 320
        maxDialogWidth: 520
        minDialogWidth: 240
        draggable: true

        onConfirmed: window.commonStatusKey = "status.common.confirmed"
        onDenied: window.commonStatusKey = "status.common.denied"
        onDismissed: window.commonStatusKey = "status.common.dismissed"
    }

    LoginDialog {
        id: loginDialog
        dialogTitle: i18n.t("login.dialog.title")
        subtitle: i18n.t("login.dialog.subtitle")
        usernameLabel: i18n.t("login.username.label")
        passwordLabel: i18n.t("login.password.label")
        usernamePlaceholder: i18n.t("login.username.placeholder")
        passwordPlaceholder: i18n.t("login.password.placeholder")
        rememberText: i18n.t("login.remember")
        loginText: i18n.t("common.confirm")
        cancelText: i18n.t("common.cancel")
        preferredWidth: 360
        maxDialogWidth: 420
        minDialogWidth: 280
        draggable: true
        userOptions: window.loginBackend.users
        maxVisibleUsers: 5

        onLoginRequested: function(username, password, rememberMe) {
            const result = window.loginBackend.validateLogin(username, password);
            if (result !== "ok") {
                loginDialog.actionHandled = false;
                errorText = i18n.t("login.error." + result);
                window.loginStatusKey = result === "empty" ? "status.login.incomplete" : "status.login.failed";
                return;
            }

            loginDialog.actionHandled = true;
            errorText = "";
            window.loginStatusUser = username;
            window.loginStatusRemember = rememberMe;
            window.loginStatusKey = "status.login.submitted";
            close();
        }

        onCancelled: window.loginStatusKey = "status.login.cancelled"
        onDismissed: window.loginStatusKey = "status.login.dismissed"
    }
    LoadingDialog {
        id: loadingDialog
        dialogTitle: i18n.t("loading.dialog.title")
        message: i18n.t("loading.dialog.message")
        detailText: i18n.t("loading.dialog.detail")
        cancelText: i18n.t("common.cancel")
        showCancelButton: true
        showCloseButton: true

        onCancelled: {
            loadingCloseTimer.stop();
            window.loadingStatusKey = "status.loading.cancelled";
        }

        onDismissed: {
            loadingCloseTimer.stop();
            if (window.loadingStatusKey === "status.loading.running")
                window.loadingStatusKey = "status.loading.dismissed";
        }
    }

    ProgressDialog {
        id: progressDialog
        dialogTitle: i18n.t("progress.dialog.title")
        message: i18n.t("progress.dialog.message")
        detailText: i18n.language === "en_US" ? "Auto progress demo. Close it when complete." : i18n.t("progress.dialog.detail")
        progressLabel: i18n.t("progress.current")
        cancelText: i18n.t("common.cancel")
        closeText: i18n.language === "en_US" ? "Close" : "\u5173\u95ed"
        minimum: 0
        maximum: 100
        striped: true
        onCancelled: progressDialogTimer.stop()
        onDismissed: progressDialogTimer.stop()
    }

    Timer {
        id: loadingCloseTimer
        interval: 2200
        repeat: false

        onTriggered: {
            loadingDialog.actionHandled = true;
            loadingDialog.close();
            window.loadingStatusKey = "status.loading.done";
        }
    }

    Timer {
        id: progressDialogTimer
        interval: 320
        repeat: true

        onTriggered: {
            window.progressValue = Math.min(100, window.progressValue + 8);
            if (window.progressValue >= 100)
                stop();
        }
    }
}
