pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls.Basic as Basic
import QtQuick.Layouts
import "components"
import "components/controls"
import "components/theme"
import "test"

Basic.ApplicationWindow {
    id: window

    width: 1100
    height: 680
    minimumWidth: 860
    minimumHeight: 560
    visible: true
    title: i18n.t("app.title")

    property int currentPage: 1
    property string commonStatusKey: "status.common.initial"
    property string loginStatusKey: "status.login.initial"
    property string loadingStatusKey: "status.loading.initial"
    property string loginStatusUser: ""
    property string loginAddedUser: ""
    property string loginStatusDetail: ""
    property bool loginStatusRemember: false
    property var loginBackend: LoginBackend
    property var progressBackend: ProgressBackend

    readonly property var navItems: [
        { "title": i18n.t("card.common.title"), "desc": i18n.t("page.common.summary") },
        { "title": i18n.t("card.login.title"), "desc": i18n.t("page.login.summary") },
        { "title": i18n.t("card.loading.title"), "desc": i18n.t("page.loading.summary") },
        { "title": i18n.t("card.progress.title"), "desc": i18n.t("page.progress.summary") },
        { "title": i18n.t("card.message.title"), "desc": i18n.t("page.message.summary") }
    ]
    readonly property string commonStatus: i18n.t(commonStatusKey)
    readonly property string loadingStatus: i18n.t(loadingStatusKey)
    readonly property string loginStatus: loginStatusKey === "status.login.submitted"
                                           ? i18n.t("status.login.submitted") + loginStatusUser + (loginStatusRemember ? i18n.t("status.login.remember") : "")
                                           : (loginStatusKey === "status.login.userAdded"
                                              ? i18n.t("status.login.userAdded") + loginAddedUser
                                              : (loginStatusKey === "status.login.userDeleted"
                                                 ? loginStatusDetail
                                                 : i18n.t(loginStatusKey)))
    readonly property bool showLoginResult: loginStatusKey !== "status.login.initial"
    readonly property string loginResultTitle: loginStatusKey === "status.login.submitted"
                                                ? i18n.t("login.result.success.title")
                                                : (loginStatusKey === "status.login.failed"
                                                   ? i18n.t("login.result.failed.title")
                                                   : (loginStatusKey === "status.login.userAdded"
                                                      ? i18n.t("login.result.added.title")
                                                      : (loginStatusKey === "status.login.userDeleted"
                                                         ? i18n.t("login.result.deleted.title")
                                                         : i18n.t("login.result.notice.title"))))
    readonly property string loginResultMessage: loginStatusKey === "status.login.submitted"
                                                  ? i18n.t("login.result.success.message") + loginStatusUser
                                                  : (loginStatusDetail.length > 0 ? loginStatusDetail : loginStatus)

    function progressStatusType() {
        if (!progressBackend)
            return AppProgressBar.Normal;
        if (progressBackend.state === "completed")
            return AppProgressBar.Success;
        if (progressBackend.state === "cancelled")
            return AppProgressBar.Warning;
        if (progressBackend.state === "error")
            return AppProgressBar.Error;

        return AppProgressBar.Normal;
    }

    function progressMessageType() {
        if (!progressBackend || progressBackend.state === "idle" || progressBackend.state === "completed")
            return AppMessage.Normal;
        if (progressBackend.state === "cancelled")
            return AppMessage.Warning;
        if (progressBackend.state === "error")
            return AppMessage.Error;

        return AppMessage.Normal;
    }

    function openProgressTask(taskType) {
        if (!progressBackend)
            return;

        progressBackend.startTask(taskType);
        progressDialog.open();
    }

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

    RowLayout {
        anchors.fill: parent
        anchors.margins: 18
        spacing: 18

        Rectangle {
            Layout.preferredWidth: 232
            Layout.fillHeight: true
            radius: theme.dialogRadius
            color: theme.panel
            border.color: theme.borderLight
            border.width: 1

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 16
                spacing: 16

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 6

                    Text {
                        Layout.fillWidth: true
                        text: i18n.t("page.title")
                        color: theme.textPrimary
                        font.pixelSize: 20
                        font.bold: true
                        wrapMode: Text.WordWrap
                    }

                    Text {
                        Layout.fillWidth: true
                        text: i18n.t("page.subtitle")
                        color: theme.textMuted
                        font.pixelSize: 12
                        lineHeight: 1.15
                        wrapMode: Text.WordWrap
                    }
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 8

                    Repeater {
                        model: window.navItems

                        delegate: Rectangle {
                            id: navDelegate

                            required property int index
                            required property var modelData

                            Layout.fillWidth: true
                            Layout.preferredHeight: 62
                            radius: theme.radiusMedium
                            color: window.currentPage === index ? theme.primarySoft : "transparent"
                            border.color: window.currentPage === index ? "#BBD7FF" : "transparent"
                            border.width: 1

                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: 12
                                anchors.rightMargin: 10
                                spacing: 10

                                Rectangle {
                                    Layout.preferredWidth: 4
                                    Layout.preferredHeight: 30
                                    radius: 2
                                    color: window.currentPage === navDelegate.index ? theme.primary : theme.borderLight
                                }

                                ColumnLayout {
                                    Layout.fillWidth: true
                                    spacing: 3

                                    Text {
                                        Layout.fillWidth: true
                                        text: navDelegate.modelData.title
                                        color: window.currentPage === navDelegate.index ? theme.primaryPressed : theme.textPrimary
                                        font.pixelSize: 14
                                        font.bold: true
                                        elide: Text.ElideRight
                                    }

                                    Text {
                                        Layout.fillWidth: true
                                        text: navDelegate.modelData.desc
                                        color: theme.textMuted
                                        font.pixelSize: 11
                                        elide: Text.ElideRight
                                    }
                                }
                            }

                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: window.currentPage = navDelegate.index
                            }
                        }
                    }
                }

                Item {
                    Layout.fillHeight: true
                }

                LanguageSwitch {
                    Layout.fillWidth: true
                    currentLanguage: i18n.language
                    languages: i18n.languageOptions
                    label: i18n.t("language.label")
                    onLanguageSelected: function(language) {
                        i18n.setLanguage(language);
                    }
                }
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 14

            RowLayout {
                Layout.fillWidth: true
                spacing: 12

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 5

                    Text {
                        Layout.fillWidth: true
                        text: window.navItems[window.currentPage].title
                        color: theme.textPrimary
                        font.pixelSize: 24
                        font.bold: true
                        elide: Text.ElideRight
                    }

                    Text {
                        Layout.fillWidth: true
                        text: window.navItems[window.currentPage].desc
                        color: theme.textMuted
                        font.pixelSize: 13
                        wrapMode: Text.WordWrap
                    }
                }
            }

            StackLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                currentIndex: window.currentPage

                PageScroll {
                    DemoPanel {
                        title: i18n.t("card.common.title")
                        badgeText: i18n.t("page.frontend")
                        description: i18n.t("card.common.desc")

                        Text {
                            Layout.fillWidth: true
                            text: i18n.t("status.prefix") + window.commonStatus
                            color: theme.textSecondary
                            font.pixelSize: 13
                            elide: Text.ElideRight
                        }

                        AppButton {
                            text: i18n.t("card.common.open")
                            type: AppButton.Primary
                            minimumWidth: 128
                            controlHeight: 34
                            onClicked: commonDialog.open()
                        }
                    }
                }

                PageScroll {
                    GridLayout {
                        Layout.fillWidth: true
                        columns: width < 760 ? 1 : 2
                        columnSpacing: 16
                        rowSpacing: 16

                        DemoPanel {
                            title: i18n.t("login.frontend.title")
                            badgeText: i18n.t("page.frontend")
                            description: i18n.t("card.login.desc")
                            Layout.alignment: Qt.AlignTop
                            Layout.minimumHeight: 320

                            Text {
                                Layout.fillWidth: true
                                text: i18n.t("status.prefix") + window.loginStatus
                                color: theme.textSecondary
                                font.pixelSize: 13
                                elide: Text.ElideRight
                            }

                            AppMessage {
                                Layout.fillWidth: true
                                visible: window.showLoginResult
                                type: window.loginStatusKey === "status.login.submitted" || window.loginStatusKey === "status.login.userAdded"
                                      ? AppMessage.Normal
                                      : (window.loginStatusKey === "status.login.failed" ? AppMessage.Error : AppMessage.Warning)
                                title: window.loginResultTitle
                                message: window.loginResultMessage
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                Layout.preferredHeight: 88
                                radius: theme.radiusMedium
                                color: theme.fieldIdle
                                border.color: theme.borderLight
                                border.width: 1

                                ColumnLayout {
                                    anchors.fill: parent
                                    anchors.margins: 12
                                    spacing: 6

                                    Text {
                                        Layout.fillWidth: true
                                        text: i18n.t("login.frontend.flow")
                                        color: theme.textPrimary
                                        font.pixelSize: 13
                                        font.bold: true
                                        elide: Text.ElideRight
                                    }

                                    Text {
                                        Layout.fillWidth: true
                                        text: i18n.t("login.frontend.note")
                                        color: theme.textMuted
                                        font.pixelSize: 12
                                        lineHeight: 1.15
                                        wrapMode: Text.WordWrap
                                    }
                                }
                            }

                            AppButton {
                                text: i18n.t("card.login.open")
                                type: AppButton.Primary
                                minimumWidth: 128
                                controlHeight: 34
                                onClicked: {
                                    loginDialog.errorText = "";
                                    loginDialog.open();
                                }
                            }
                        }

                        LoginBackendPanel {
                            backend: window.loginBackend
                            i18n: i18n
                            badgeText: i18n.t("page.backend")
                            Layout.alignment: Qt.AlignTop
                            Layout.minimumHeight: 320
                            onUserAdded: function(username) {
                                window.loginAddedUser = username;
                                window.loginStatusKey = "status.login.userAdded";
                                window.loginStatusDetail = i18n.t("login.test.added") + username;
                                Qt.callLater(function() {
                                    loginDialog.selectUser(username);
                                });
                            }
                            onUserDeleted: function(username) {
                                window.loginStatusDetail = i18n.t("login.delete.done") + username;
                                window.loginStatusKey = "status.login.userDeleted";
                            }
                        }
                    }
                }

                PageScroll {
                    DemoPanel {
                        title: i18n.t("card.loading.title")
                        badgeText: i18n.t("page.frontend")
                        description: i18n.t("card.loading.desc")

                        Text {
                            Layout.fillWidth: true
                            text: i18n.t("status.prefix") + window.loadingStatus
                            color: theme.textSecondary
                            font.pixelSize: 13
                            elide: Text.ElideRight
                        }

                        AppButton {
                            text: i18n.t("card.loading.open")
                            type: AppButton.Primary
                            minimumWidth: 128
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

                PageScroll {
                    GridLayout {
                        Layout.fillWidth: true
                        columns: width < 760 ? 1 : 2
                        columnSpacing: 16
                        rowSpacing: 16

                        DemoPanel {
                            title: i18n.t("progress.frontend.title")
                            badgeText: i18n.t("page.frontend")
                            description: i18n.t("card.progress.desc")
                            Layout.alignment: Qt.AlignTop
                            Layout.minimumHeight: 320

                            Text {
                                Layout.fillWidth: true
                                text: i18n.t("status.prefix") + (window.progressBackend ? i18n.t(window.progressBackend.phaseKey) : i18n.t("progress.phase.idle"))
                                color: theme.textSecondary
                                font.pixelSize: 13
                                elide: Text.ElideRight
                            }

                            AppMessage {
                                Layout.fillWidth: true
                                type: window.progressMessageType()
                                title: window.progressBackend ? i18n.t(window.progressBackend.taskKey) : i18n.t("progress.task.none")
                                message: window.progressBackend ? i18n.t(window.progressBackend.detailKey) : i18n.t("progress.detail.idle")
                            }

                            AppProgressBar {
                                Layout.fillWidth: true
                                minimum: window.progressBackend ? window.progressBackend.minimum : 0
                                maximum: window.progressBackend ? window.progressBackend.maximum : 100
                                value: window.progressBackend ? window.progressBackend.value : 0
                                label: i18n.t("progress.current")
                                suffix: "%"
                                status: window.progressStatusType()
                                striped: window.progressBackend ? window.progressBackend.running : false
                                barHeight: 8
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                Layout.preferredHeight: 88
                                radius: theme.radiusMedium
                                color: theme.fieldIdle
                                border.color: theme.borderLight
                                border.width: 1

                                ColumnLayout {
                                    anchors.fill: parent
                                    anchors.margins: 12
                                    spacing: 6

                                    Text {
                                        Layout.fillWidth: true
                                        text: i18n.t("progress.frontend.flow")
                                        color: theme.textPrimary
                                        font.pixelSize: 13
                                        font.bold: true
                                        elide: Text.ElideRight
                                    }

                                    Text {
                                        Layout.fillWidth: true
                                        text: i18n.t("progress.frontend.note")
                                        color: theme.textMuted
                                        font.pixelSize: 12
                                        lineHeight: 1.15
                                        wrapMode: Text.WordWrap
                                    }
                                }
                            }

                            AppButton {
                                text: i18n.t("card.progress.advance")
                                type: AppButton.Primary
                                minimumWidth: 128
                                controlHeight: 34
                                enabled: !window.progressBackend || !window.progressBackend.running
                                onClicked: window.openProgressTask("batch")
                            }
                        }

                        ProgressBackendPanel {
                            backend: window.progressBackend
                            i18n: i18n
                            badgeText: i18n.t("page.backend")
                            Layout.alignment: Qt.AlignTop
                            Layout.minimumHeight: 320
                        }
                    }
                }

                PageScroll {
                    DemoPanel {
                        title: i18n.t("card.message.title")
                        badgeText: i18n.t("page.frontend")
                        description: i18n.t("card.message.desc")
                        Layout.minimumHeight: 330

                        AppMessage {
                            id: normalMessageDemo
                            Layout.fillWidth: true
                            type: AppMessage.Normal
                            closable: true
                            title: i18n.t("message.normal.title")
                            message: i18n.t("message.normal.text")
                        }

                        AppMessage {
                            id: warningMessageDemo
                            Layout.fillWidth: true
                            type: AppMessage.Warning
                            closable: true
                            title: i18n.t("message.warning.title")
                            message: i18n.t("message.warning.text")
                        }

                        AppMessage {
                            id: errorMessageDemo
                            Layout.fillWidth: true
                            type: AppMessage.Error
                            closable: true
                            title: i18n.t("message.error.title")
                            message: i18n.t("message.error.text")
                        }

                        AppButton {
                            text: i18n.t("message.restore")
                            minimumWidth: 96
                            controlHeight: 32
                            onClicked: {
                                normalMessageDemo.reopen();
                                warningMessageDemo.reopen();
                                errorMessageDemo.reopen();
                            }
                        }
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
        draggable: true
        userOptions: window.loginBackend.users
        maxVisibleUsers: 5

        onLoginRequested: function(username, password, rememberMe) {
            const result = window.loginBackend.validateLogin(username, password);
            if (result !== "ok") {
                loginDialog.actionHandled = false;
                errorText = i18n.t("login.error." + result);
                window.loginStatusDetail = errorText;
                window.loginStatusKey = result === "empty" ? "status.login.incomplete" : "status.login.failed";
                return;
            }

            loginDialog.actionHandled = true;
            errorText = "";
            window.loginStatusUser = username;
            window.loginStatusRemember = rememberMe;
            window.loginStatusDetail = i18n.t("login.result.success.message") + username;
            window.loginStatusKey = "status.login.submitted";
            close();
        }

        onCancelled: {
            window.loginStatusDetail = i18n.t("status.login.cancelled");
            window.loginStatusKey = "status.login.cancelled";
        }
        onDismissed: {
            window.loginStatusDetail = i18n.t("status.login.dismissed");
            window.loginStatusKey = "status.login.dismissed";
        }
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
        message: window.progressBackend ? i18n.t(window.progressBackend.taskKey) : i18n.t("progress.dialog.message")
        detailText: window.progressBackend ? i18n.t(window.progressBackend.phaseKey) : i18n.t("progress.dialog.detail")
        progressLabel: i18n.t("progress.current")
        cancelText: i18n.t("common.cancel")
        closeText: i18n.t("progress.close")
        minimum: window.progressBackend ? window.progressBackend.minimum : 0
        maximum: window.progressBackend ? window.progressBackend.maximum : 100
        value: window.progressBackend ? window.progressBackend.value : 0
        status: window.progressStatusType()
        striped: true
        showCancelButton: window.progressBackend ? window.progressBackend.running : false
        onCancelled: {
            if (window.progressBackend)
                window.progressBackend.cancelTask();
        }
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

}
