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
    preferredWidth: 360
    minDialogWidth: 300
    maxDialogWidth: 460
    contentPadding: 22
    showIcon: true
    iconText: "!"
    iconSize: 22
    titleFontSize: 16
    subtitleFontSize: 13
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
            minimumWidth: 72
            controlHeight: 34
            onClicked: {
                root.actionHandled = true;
                root.denied();
                root.close();
            }
        },
        AppButton {
            type: AppButton.Primary
            text: root.confirmText
            minimumWidth: 72
            controlHeight: 34
            onClicked: {
                root.actionHandled = true;
                root.confirmed();
                root.close();
            }
        }
    ]
}
