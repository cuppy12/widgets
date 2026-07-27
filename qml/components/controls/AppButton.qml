import QtQuick
import "../theme"

Item {
    id: root

    enum Type {
        Default,
        Primary,
        Danger
    }

    property string text: ""
    property int type: AppButton.Default
    property bool enabled: true
    property int minimumWidth: 64
    property int horizontalPadding: 24
    property int controlHeight: theme.controlHeight

    readonly property color currentColor: root.type === AppButton.Primary
                                         ? (buttonMouse.pressed ? theme.primaryPressed : (buttonMouse.containsMouse ? theme.primaryHover : theme.primary))
                                         : (root.type === AppButton.Danger
                                            ? (buttonMouse.pressed ? "#991B1B" : (buttonMouse.containsMouse ? "#EF4444" : theme.danger))
                                            : (buttonMouse.containsMouse ? theme.fieldIdle : theme.panel))

    signal clicked()

    implicitWidth: Math.max(minimumWidth, label.implicitWidth + horizontalPadding)
    implicitHeight: controlHeight
    opacity: enabled ? 1.0 : 0.55

    AppTheme {
        id: theme
    }

    Rectangle {
        anchors.fill: parent
        radius: theme.radiusSmall
        color: root.currentColor
        border.color: root.type === AppButton.Default ? theme.border : "transparent"
        border.width: root.type === AppButton.Default ? 1 : 0
    }

    Text {
        id: label
        anchors.centerIn: parent
        width: Math.max(0, parent.width - 12)
        text: root.text
        color: root.type === AppButton.Default ? "#374151" : theme.textOnPrimary
        font.pixelSize: 13
        elide: Text.ElideRight
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    MouseArea {
        id: buttonMouse
        anchors.fill: parent
        enabled: root.enabled
        hoverEnabled: true
        cursorShape: root.enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
        onClicked: root.clicked()
    }
}
