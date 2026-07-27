import QtQuick
import "../theme"

Item {
    id: root

    property alias text: input.text
    property string label: ""
    property string placeholderText: ""
    property bool passwordMode: false
    property bool revealable: false
    property bool passwordVisible: false
    property bool enabled: true
    readonly property bool inputActiveFocus: input.activeFocus

    signal accepted()

    function forceInputFocus() {
        input.forceActiveFocus();
    }

    implicitWidth: 260
    implicitHeight: theme.fieldHeight
    opacity: enabled ? 1.0 : 0.55

    AppTheme {
        id: theme
    }

    TextMetrics {
        id: labelMetrics
        text: root.label
        font.pixelSize: 12
    }

    Rectangle {
        anchors.fill: parent
        radius: theme.radiusMedium
        color: input.activeFocus ? theme.panel : theme.fieldIdle
        border.color: input.activeFocus ? theme.primary : theme.border
        border.width: 1
    }

    Text {
        id: labelText
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.verticalCenter: parent.verticalCenter
        visible: root.label.length > 0
        width: visible ? Math.min(86, labelMetrics.advanceWidth) : 0
        text: root.label
        color: theme.textMuted
        font.pixelSize: 12
        elide: Text.ElideRight
    }

    TextInput {
        id: input
        anchors.left: parent.left
        anchors.leftMargin: root.label.length > 0 ? labelText.width + 20 : 10
        anchors.right: parent.right
        anchors.rightMargin: root.passwordMode && root.revealable ? 40 : 10
        anchors.verticalCenter: parent.verticalCenter
        height: 24
        enabled: root.enabled
        clip: true
        color: theme.textPrimary
        font.pixelSize: 13
        echoMode: root.passwordMode && !root.passwordVisible ? TextInput.Password : TextInput.Normal
        selectByMouse: true
        verticalAlignment: TextInput.AlignVCenter

        Text {
            anchors.fill: parent
            visible: input.text.length === 0 && !input.activeFocus
            text: root.placeholderText
            color: theme.textPlaceholder
            font: input.font
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }

        Keys.onReturnPressed: root.accepted()
        Keys.onEnterPressed: root.accepted()
    }

    Item {
        id: revealButton
        anchors.right: parent.right
        anchors.rightMargin: 8
        anchors.verticalCenter: parent.verticalCenter
        visible: root.passwordMode && root.revealable
        width: 24
        height: 24

        Rectangle {
            anchors.fill: parent
            radius: width / 2
            color: revealMouse.containsMouse ? theme.hoverLight : "transparent"
        }

        AppEyeIcon {
            anchors.centerIn: parent
            width: 18
            height: 18
            color: theme.textMuted
            crossed: !root.passwordVisible
        }



        MouseArea {
            id: revealMouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: root.passwordVisible = !root.passwordVisible
        }
    }
}
