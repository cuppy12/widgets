import QtQuick
import "../theme"

Item {
    id: root

    property bool checked: false
    property string text: ""
    property bool enabled: true

    signal toggled(bool checked)

    implicitWidth: box.width + (label.visible ? 8 + label.implicitWidth : 0)
    implicitHeight: Math.max(18, label.implicitHeight)
    opacity: enabled ? 1.0 : 0.55

    AppTheme {
        id: theme
    }

    Rectangle {
        id: box
        width: 16
        height: 16
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        radius: 3
        color: root.checked ? theme.primary : theme.panel
        border.color: root.checked ? theme.primary : theme.border
        border.width: 1

        Text {
            anchors.centerIn: parent
            visible: root.checked
            text: "✓"
            color: theme.textOnPrimary
            font.pixelSize: 12
            font.bold: true
        }
    }

    Text {
        id: label
        anchors.left: box.right
        anchors.leftMargin: 8
        anchors.verticalCenter: parent.verticalCenter
        visible: root.text.length > 0
        text: root.text
        color: theme.textSecondary
        font.pixelSize: 12
    }

    MouseArea {
        anchors.fill: parent
        enabled: root.enabled
        hoverEnabled: true
        cursorShape: root.enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
        onClicked: {
            root.checked = !root.checked;
            root.toggled(root.checked);
        }
    }
}