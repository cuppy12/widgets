import QtQuick
import QtQuick.Layouts
import "base"
import "controls"
import "theme"

DialogBase {
    id: root

    property string dialogTitle: "Login"
    readonly property string username: usernameBox.currentText
    property alias password: passwordField.text
    property var userOptions: []
    property alias currentUserIndex: usernameBox.currentIndex
    property int maxVisibleUsers: 5
    property string usernameLabel: "Account"
    property string passwordLabel: "Password"
    property string usernamePlaceholder: "Select account"
    property string passwordPlaceholder: "Password"
    property string emptyUserText: "No accounts"
    property string rememberText: "Remember me"
    property string loginText: "Login"
    property string cancelText: "Cancel"
    property string errorText: ""
    property alias rememberMe: rememberCheck.checked

    signal loginRequested(string username, string password, bool rememberMe)
    signal cancelled()

    function clearPassword() {
        passwordField.text = "";
    }

    function selectUser(username) {
        for (let i = 0; i < usernameBox.modelCount; ++i) {
            if (usernameBox.resolveText(i) === username) {
                usernameBox.currentIndex = i;
                usernameBox.highlightedIndex = i;
                return;
            }
        }
    }

    function submit() {
        root.loginRequested(usernameBox.currentText, passwordField.text, rememberCheck.checked);
    }

    title: dialogTitle
    subtitle: "Select an account and enter the password"
    preferredWidth: 390
    minDialogWidth: 320
    maxDialogWidth: 460
    contentPadding: 28
    headerSpacing: 14
    bodySpacing: 18
    bodyHorizontalInset: 4
    footerSpacing: 12
    titleSubtitleSpacing: 7
    showIcon: true
    iconText: "->"
    iconSize: 34
    closeOnPressOutside: false
    iconColor: theme.primary
    iconBackgroundColor: theme.primarySoft

    onOpened: usernameBox.forceInputFocus()

    AppTheme {
        id: theme
    }

    ColumnLayout {
        Layout.fillWidth: true
        spacing: 12

        AppComboBox {
            id: usernameBox
            Layout.fillWidth: true
            label: root.usernameLabel
            placeholderText: root.usernamePlaceholder
            emptyText: root.emptyUserText
            model: root.userOptions
            maxVisibleItems: root.maxVisibleUsers
            onActivated: passwordField.forceInputFocus()
        }

        AppTextField {
            id: passwordField
            Layout.fillWidth: true
            label: root.passwordLabel
            placeholderText: root.passwordPlaceholder
            passwordMode: true
            revealable: true
            onInputActiveFocusChanged: {
                if (inputActiveFocus)
                    usernameBox.closePopup();
            }
            onAccepted: root.submit()
        }

        AppCheckBox {
            id: rememberCheck
            Layout.topMargin: 2
            text: root.rememberText
        }

        Text {
            Layout.fillWidth: true
            Layout.topMargin: 2
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
            minimumWidth: 72
            controlHeight: 34
            onClicked: {
                root.actionHandled = true;
                root.cancelled();
                root.close();
            }
        },
        AppButton {
            type: AppButton.Primary
            text: root.loginText
            minimumWidth: 86
            controlHeight: 34
            onClicked: root.submit()
        }
    ]
}
