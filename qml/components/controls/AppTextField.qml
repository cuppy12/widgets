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
        text: root.label
        color: theme.textMuted
        font.pixelSize: 12
    }

    TextInput {
        id: input
        anchors.left: parent.left
        anchors.leftMargin: root.label.length > 0 ? 46 : 10
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

    AppIconButton {
        anchors.right: parent.right
        anchors.rightMargin: 8
        anchors.verticalCenter: parent.verticalCenter
        visible: root.passwordMode && root.revealable
        size: 24
        text: root.passwordVisible ? "明" : "隐"
        textColor: theme.textMuted
        onClicked: root.passwordVisible = !root.passwordVisible
    }
}