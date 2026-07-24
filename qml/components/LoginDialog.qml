import QtQuick
import QtQuick.Layouts
import "base"
import "controls"
import "theme"

DialogBase {
    id: root

    property string dialogTitle: "用户登录"
    property alias username: usernameField.text
    property alias password: passwordField.text
    property string usernamePlaceholder: "用户名"
    property string passwordPlaceholder: "密码"
    property string loginText: "登录"
    property string cancelText: "取消"
    property string errorText: ""
    property alias rememberMe: rememberCheck.checked

    signal loginRequested(string username, string password, bool rememberMe)
    signal cancelled()

    function clearPassword() {
        passwordField.text = "";
    }

    function submit() {
        root.actionHandled = true;
        root.loginRequested(usernameField.text, passwordField.text, rememberCheck.checked);
    }

    title: dialogTitle
    subtitle: "请输入账号和密码"
    preferredWidth: 360
    minDialogWidth: 280
    maxDialogWidth: 420
    showIcon: true
    iconText: "→"
    iconSize: 34
    iconColor: theme.primary
    iconBackgroundColor: theme.primarySoft

    onOpened: usernameField.forceInputFocus()

    AppTheme {
        id: theme
    }

    ColumnLayout {
        Layout.fillWidth: true
        spacing: 10

        AppTextField {
            id: usernameField
            Layout.fillWidth: true
            label: "用户"
            placeholderText: root.usernamePlaceholder
            onAccepted: passwordField.forceInputFocus()
        }

        AppTextField {
            id: passwordField
            Layout.fillWidth: true
            label: "密码"
            placeholderText: root.passwordPlaceholder
            passwordMode: true
            revealable: true
            onAccepted: root.submit()
        }

        AppCheckBox {
            id: rememberCheck
            text: "记住登录"
        }

        Text {
            Layout.fillWidth: true
            visible: root.errorText.length > 0
            text: root.errorText
            color: theme.danger
            font.pixelSize: 12
            wrapMode: Text.WordWrap
        }
    }

    footerData: [
        AppButton {
            text: root.cancelText
            minimumWidth: 62
            onClicked: {
                root.actionHandled = true;
                root.cancelled();
                root.close();
            }
        },
        AppButton {
            type: AppButton.Primary
            text: root.loginText
            minimumWidth: 78
            onClicked: root.submit()
        }
    ]
}