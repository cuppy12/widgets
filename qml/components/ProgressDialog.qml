import QtQuick
import QtQuick.Layouts
import "base"
import "controls"
import "theme"

DialogBase {
    id: root

    enum Status {
        Normal,
        Success,
        Warning,
        Error
    }

    property string dialogTitle: "任务进度"
    property string message: "正在处理任务，请稍候。"
    property string detailText: ""
    property string cancelText: "取消"
    property string closeText: "关闭"
    property string progressLabel: ""
    property string suffix: "%"
    property real minimum: 0
    property real maximum: 100
    property real value: 0
    property bool indeterminate: false
    property bool striped: true
    property bool showCancelButton: true
    property int status: ProgressDialog.Normal

    readonly property real range: Math.max(0.0001, maximum - minimum)
    readonly property real normalizedValue: Math.max(0, Math.min(1, (value - minimum) / range))
    readonly property int percent: Math.round(normalizedValue * 100)
    readonly property bool completed: !indeterminate && normalizedValue >= 1
    readonly property bool closeMode: completed || !showCancelButton

    signal cancelled()

    function cancel() {
        root.actionHandled = true;
        root.cancelled();
        root.close();
    }

    title: dialogTitle
    subtitle: message
    preferredWidth: 360
    minDialogWidth: 280
    maxDialogWidth: 460
    closeOnPressOutside: false
    modal: true
    dim: true
    showIcon: true
    iconText: "%"
    iconSize: 34
    iconColor: theme.primary
    iconBackgroundColor: theme.primarySoft

    AppTheme {
        id: theme
    }

    ColumnLayout {
        Layout.fillWidth: true
        spacing: 10

        Text {
            Layout.fillWidth: true
            visible: root.detailText.length > 0
            text: root.detailText
            color: theme.textMuted
            font.pixelSize: 12
            wrapMode: Text.WordWrap
        }

        AppProgressBar {
            Layout.fillWidth: true
            minimum: root.minimum
            maximum: root.maximum
            value: root.value
            indeterminate: root.indeterminate
            striped: root.striped
            status: root.completed ? AppProgressBar.Success : root.status
            label: root.progressLabel
            suffix: root.suffix
            showText: !root.indeterminate
            barHeight: 8
        }
    }

    footerData: [
        AppButton {
            text: root.closeMode ? root.closeText : root.cancelText
            minimumWidth: 70
            onClicked: {
                if (root.closeMode) {
                    root.actionHandled = true;
                    root.close();
                } else {
                    root.cancel();
                }
            }
        }
    ]
}
