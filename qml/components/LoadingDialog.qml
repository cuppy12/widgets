pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import "base"
import "controls"
import "theme"

DialogBase {
    id: root

    property string dialogTitle: "正在加载"
    property string message: "请稍候，正在处理数据。"
    property string detailText: ""
    property string cancelText: "取消"
    property real progress: -1
    property bool showCancelButton: false

    readonly property real normalizedProgress: Math.max(0, Math.min(1, progress))
    readonly property bool hasProgress: progress >= 0

    signal cancelled()

    function cancel() {
        root.actionHandled = true;
        root.cancelled();
        root.close();
    }

    title: dialogTitle
    subtitle: message
    preferredWidth: 380
    minDialogWidth: 300
    maxDialogWidth: 440
    contentPadding: 26
    bodySpacing: 14
    bodyHorizontalInset: 28
    titleSubtitleSpacing: 7
    preferredAspectRatio: 2.05
    showFooter: showCancelButton
    closeOnPressOutside: false
    modal: true
    dim: true
    showIcon: false

    AppTheme {
        id: theme
    }

    ColumnLayout {
        Layout.fillWidth: true
        spacing: 12

        Item {
            id: spinner
            Layout.preferredWidth: 38
            Layout.preferredHeight: 38
            Layout.alignment: Qt.AlignHCenter

            NumberAnimation on rotation {
                from: 0
                to: 360
                duration: 900
                loops: Animation.Infinite
                running: root.opened
            }

            Repeater {
                model: 12

                Rectangle {
                    required property int index

                    width: 5
                    height: 5
                    radius: 2.5
                    color: theme.primary
                    opacity: 0.20 + index * 0.06
                    x: spinner.width / 2 - width / 2 + Math.cos((index * 30 - 90) * Math.PI / 180) * 14
                    y: spinner.height / 2 - height / 2 + Math.sin((index * 30 - 90) * Math.PI / 180) * 14
                }
            }
        }

        Text {
            Layout.fillWidth: true
            visible: root.detailText.length > 0
            text: root.detailText
            color: theme.textMuted
            font.pixelSize: 12
            lineHeight: 1.18
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
        }

        AppProgressBar {
            Layout.fillWidth: true
            visible: root.hasProgress
            minimum: 0
            maximum: 1
            value: root.normalizedProgress
            showText: false
            barHeight: 6
        }
    }

    footerData: [
        AppButton {
            visible: root.showCancelButton
            text: root.cancelText
            minimumWidth: 72
            controlHeight: 34
            onClicked: root.cancel()
        }
    ]
}
