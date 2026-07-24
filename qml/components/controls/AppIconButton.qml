import QtQuick
import "../theme"

Item {
    id: root

    property string text: "×"
    property int size: 24
    property color textColor: theme.textMuted
    property color hoverColor: theme.hoverLight
    property bool enabled: true

    signal clicked()

    implicitWidth: size
    implicitHeight: size
    opacity: enabled ? 1.0 : 0.45

    AppTheme {
        id: theme
    }

    Rectangle {
        anchors.fill: parent
        radius: width / 2
        color: iconMouse.containsMouse ? root.hoverColor : "transparent"
    }

    Text {
        anchors.centerIn: parent
        text: root.text
        color: root.textColor
        font.pixelSize: Math.max(14, root.size - 6)
        lineHeight: 0.8
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    MouseArea {
        id: iconMouse
        anchors.fill: parent
        enabled: root.enabled
        hoverEnabled: true
        cursorShape: root.enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
        onClicked: root.clicked()
    }
}