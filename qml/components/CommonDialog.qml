import QtQuick
import QtQuick.Layouts
import "base"
import "controls"
import "theme"

DialogBase {
    id: root

    property string dialogTitle: "提示"
    property string message: ""
    property string confirmText: "确认"
    property string cancelText: "取消"
    default property alias dialogContent: customContent.data

    signal confirmed()
    signal denied()

    title: dialogTitle
    subtitle: message
    preferredWidth: 320
    minDialogWidth: 240
    maxDialogWidth: 520
    showIcon: true
    iconText: "!"
    iconSize: 16
    iconColor: theme.textOnPrimary
    iconBackgroundColor: theme.warning

    AppTheme {
        id: theme
    }

    ColumnLayout {
        id: customContent
        Layout.fillWidth: true
        visible: children.length > 0
        spacing: theme.spacingSmall
    }

    footerData: [
        AppButton {
            text: root.cancelText
            onClicked: {
                root.actionHandled = true;
                root.denied();
                root.close();
            }
        },
        AppButton {
            type: AppButton.Primary
            text: root.confirmText
            onClicked: {
                root.actionHandled = true;
                root.confirmed();
                root.close();
            }
        }
    ]
}