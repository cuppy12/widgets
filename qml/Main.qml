import QtQuick
import QtQuick.Controls.Basic as Basic
import QtQuick.Layouts
import "components"
import "components/controls"
import "components/theme"

Basic.ApplicationWindow {
    id: window

    width: 760
    height: 600
    visible: true
    title: "Dialog Components"

    property string commonStatus: "未操作"
    property string loginStatus: "未登录"
    property string loadingStatus: "未加载"
    property real progressValue: 38

    AppTheme {
        id: theme
    }

    Rectangle {
        anchors.fill: parent
        color: theme.page
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 24
        spacing: 18

        Text {
            Layout.fillWidth: true
            text: "组件库测试页"
            color: theme.textPrimary
            font.pixelSize: 20
            font.bold: true
        }

        GridLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            columns: window.width < 620 ? 1 : (window.width < 980 ? 2 : 4)
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
                        text: "确认弹窗"
                        color: theme.textPrimary
                        font.pixelSize: 16
                        font.bold: true
                    }

                    Text {
                        Layout.fillWidth: true
                        text: "适合危险操作、二次确认、提示用户继续或取消。标题栏可拖动，宽度可通过 preferredWidth/minDialogWidth/maxDialogWidth 控制。"
                        color: theme.textMuted
                        font.pixelSize: 13
                        wrapMode: Text.WordWrap
                    }

                    Item { Layout.fillHeight: true }

                    Text {
                        Layout.fillWidth: true
                        text: "状态：" + window.commonStatus
                        color: "#374151"
                        font.pixelSize: 13
                        elide: Text.ElideRight
                    }

                    AppButton {
                        text: "打开确认弹窗"
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
                        text: "登录弹窗"
                        color: theme.textPrimary
                        font.pixelSize: 16
                        font.bold: true
                    }

                    Text {
                        Layout.fillWidth: true
                        text: "包含用户名、密码、记住登录、错误提示和密码显隐。对外开放 placeholder、按钮文案和登录信号。"
                        color: theme.textMuted
                        font.pixelSize: 13
                        wrapMode: Text.WordWrap
                    }

                    Item { Layout.fillHeight: true }

                    Text {
                        Layout.fillWidth: true
                        text: "状态：" + window.loginStatus
                        color: "#374151"
                        font.pixelSize: 13
                        elide: Text.ElideRight
                    }

                    AppButton {
                        text: "打开登录弹窗"
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
                        text: "加载弹窗"
                        color: theme.textPrimary
                        font.pixelSize: 16
                        font.bold: true
                    }

                    Text {
                        Layout.fillWidth: true
                        text: "用于页面加载、请求处理、文件解析等等待场景，可显示不确定加载、进度和取消操作。"
                        color: theme.textMuted
                        font.pixelSize: 13
                        wrapMode: Text.WordWrap
                    }

                    Item { Layout.fillHeight: true }

                    Text {
                        Layout.fillWidth: true
                        text: "状态：" + window.loadingStatus
                        color: "#374151"
                        font.pixelSize: 13
                        elide: Text.ElideRight
                    }

                    AppButton {
                        text: "打开加载弹窗"
                        type: AppButton.Primary
                        minimumWidth: 112
                        controlHeight: 34
                        onClicked: {
                            loadingDialog.progress = -1;
                            window.loadingStatus = "加载中";
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
                        text: "进度条组件"
                        color: theme.textPrimary
                        font.pixelSize: 16
                        font.bold: true
                    }

                    Text {
                        Layout.fillWidth: true
                        text: "支持百分比、状态色、条纹动画和不确定加载态，可单独作为组件库控件使用。"
                        color: theme.textMuted
                        font.pixelSize: 13
                        wrapMode: Text.WordWrap
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 10

                        ProgressBar {
                            Layout.fillWidth: true
                            value: window.progressValue
                            striped: true
                            label: "当前"
                        }

                        ProgressBar {
                            Layout.fillWidth: true
                            value: 100
                            status: ProgressBar.Success
                            label: "完成"
                        }

                        ProgressBar {
                            Layout.fillWidth: true
                            indeterminate: true
                            showText: false
                            barHeight: 6
                            progressColor: "#6366F1"
                        }
                    }

                    Item { Layout.fillHeight: true }

                    AppButton {
                        text: "推进进度"
                        type: AppButton.Primary
                        minimumWidth: 112
                        controlHeight: 34
                        onClicked: {
                            window.progressValue += 17;
                            if (window.progressValue > 100)
                                window.progressValue = 0;
                        }
                    }
                }
            }
        }
    }

    CommonDialog {
        id: commonDialog
        dialogTitle: "确认执行此操作？"
        message: "这一步会影响当前设备状态，请确认后继续。"
        confirmText: "确认"
        cancelText: "取消"
        preferredWidth: 320
        maxDialogWidth: 520
        minDialogWidth: 240
        draggable: true

        onConfirmed: window.commonStatus = "已确认"
        onDenied: window.commonStatus = "已取消"
        onDismissed: window.commonStatus = "已关闭"
    }

    LoginDialog {
        id: loginDialog
        dialogTitle: "登录系统"
        subtitle: "使用你的账号继续"
        usernamePlaceholder: "请输入用户名"
        passwordPlaceholder: "请输入密码"
        preferredWidth: 360
        maxDialogWidth: 420
        minDialogWidth: 280
        draggable: true

        onLoginRequested: function(username, password, rememberMe) {
            if (username.length === 0 || password.length === 0) {
                errorText = "请输入用户名和密码";
                window.loginStatus = "等待输入完整信息";
                return;
            }

            errorText = "";
            window.loginStatus = "已提交：" + username + (rememberMe ? "（记住登录）" : "");
            close();
        }

        onCancelled: window.loginStatus = "已取消"
        onDismissed: window.loginStatus = "已关闭"
    }

    LoadingDialog {
        id: loadingDialog
        dialogTitle: "页面加载中"
        message: "正在加载组件和业务数据，请稍候。"
        detailText: "示例会在 2.2 秒后自动关闭。"
        showCancelButton: true
        showCloseButton: true

        onCancelled: {
            loadingCloseTimer.stop();
            window.loadingStatus = "已取消";
        }

        onDismissed: {
            loadingCloseTimer.stop();
            if (window.loadingStatus === "加载中")
                window.loadingStatus = "已关闭";
        }
    }

    Timer {
        id: loadingCloseTimer
        interval: 2200
        repeat: false

        onTriggered: {
            loadingDialog.actionHandled = true;
            loadingDialog.close();
            window.loadingStatus = "加载完成";
        }
    }
}