import QtQuick
import QtQuick.Layouts
import "base"
import "controls"
import "theme"

DialogBase {
    id: root

    property string dialogTitle: "用户注册"
    property alias username: usernameField.text
    property alias email: emailField.text
    property alias password: passwordField.text
    property alias confirmPassword: confirmPasswordField.text
    property string usernameLabel: "用户"
    property string emailLabel: "邮箱"
    property string passwordLabel: "密码"
    property string confirmPasswordLabel: "确认"
    property string usernamePlaceholder: "请输入用户名"
    property string emailPlaceholder: "请输入邮箱"
    property string passwordPlaceholder: "请输入密码"
    property string confirmPasswordPlaceholder: "请再次输入密码"
    property string agreeText: "我已阅读并同意服务条款"
    property string registerText: "注册"
    property string cancelText: "取消"
    property string errorText: ""
    property alias acceptedTerms: termsCheck.checked

    signal registerRequested(string username, string email, string password, string confirmPassword, bool acceptedTerms)
    signal cancelled()

    function clearPasswords() {
        passwordField.text = "";
        confirmPasswordField.text = "";
    }

    function submit() {
        root.actionHandled = true;
        root.registerRequested(usernameField.text, emailField.text, passwordField.text, confirmPasswordField.text, termsCheck.checked);
    }

    title: dialogTitle
    subtitle: "创建一个新账号"
    preferredWidth: 390
    minDialogWidth: 300
    maxDialogWidth: 460
    showIcon: true
    iconText: "+"
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
            label: root.usernameLabel
            placeholderText: root.usernamePlaceholder
            onAccepted: emailField.forceInputFocus()
        }

        AppTextField {
            id: emailField
            Layout.fillWidth: true
            label: root.emailLabel
            placeholderText: root.emailPlaceholder
            onAccepted: passwordField.forceInputFocus()
        }

        AppTextField {
            id: passwordField
            Layout.fillWidth: true
            label: root.passwordLabel
            placeholderText: root.passwordPlaceholder
            passwordMode: true
            revealable: true
            onAccepted: confirmPasswordField.forceInputFocus()
        }

        AppTextField {
            id: confirmPasswordField
            Layout.fillWidth: true
            label: root.confirmPasswordLabel
            placeholderText: root.confirmPasswordPlaceholder
            passwordMode: true
            revealable: true
            onAccepted: root.submit()
        }

        AppCheckBox {
            id: termsCheck
            text: root.agreeText
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
            text: root.registerText
            minimumWidth: 78
            onClicked: root.submit()
        }
    ]
}
