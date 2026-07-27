import QtQuick
import "../theme"

Item {
    id: root

    enum Type {
        Normal,
        Warning,
        Error
    }

    property int type: AppMessage.Normal
    property string title: ""
    property string message: ""
    property bool closable: false
    property bool showIcon: true
    property string iconText: defaultIconText
    property bool dismissed: false
    property bool accentBarVisible: true
    property int maxTitleLines: 1
    property int maxMessageLines: 3
    property int controlRadius: theme.radiusMedium
    property int horizontalPadding: 14
    property int verticalPadding: 12
    property color accentColor: defaultAccentColor
    property color backgroundColor: defaultBackgroundColor
    property color borderColor: defaultBorderColor
    property color titleColor: theme.textPrimary
    property color messageColor: theme.textSecondary

    readonly property string defaultIconText: type === AppMessage.Warning ? "!" : (type === AppMessage.Error ? "x" : "i")
    readonly property color defaultAccentColor: type === AppMessage.Warning ? theme.warning : (type === AppMessage.Error ? theme.danger : theme.success)
    readonly property color defaultBackgroundColor: type === AppMessage.Warning ? "#FFF8E6" : (type === AppMessage.Error ? "#FFF1F0" : "#F0FDF4")
    readonly property color defaultBorderColor: type === AppMessage.Warning ? "#FFD591" : (type === AppMessage.Error ? "#FFCCC7" : "#B7EB8F")

    signal closed()

    function close() {
        dismissed = true;
        closed();
    }

    function reopen() {
        dismissed = false;
    }

    visible: !dismissed
    implicitWidth: 320
    implicitHeight: Math.max(58, contentRow.implicitHeight + verticalPadding * 2)

    AppTheme {
        id: theme
    }

    Rectangle {
        anchors.fill: parent
        radius: root.controlRadius
        color: root.backgroundColor
        border.color: root.borderColor
        border.width: 1
    }

    Rectangle {
        visible: root.accentBarVisible
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: 4
        radius: root.controlRadius
        color: root.accentColor
    }

    Row {
        id: contentRow
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: root.horizontalPadding + (root.accentBarVisible ? 4 : 0)
        anchors.rightMargin: root.horizontalPadding
        spacing: 12

        Rectangle {
            visible: root.showIcon
            width: 26
            height: 26
            radius: 13
            color: root.accentColor
            anchors.verticalCenter: parent.verticalCenter

            Text {
                anchors.centerIn: parent
                text: root.iconText
                color: theme.textOnPrimary
                font.pixelSize: 14
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }

        Column {
            width: Math.max(0, parent.width - (root.showIcon ? 38 : 0) - (root.closable ? 30 : 0))
            anchors.verticalCenter: parent.verticalCenter
            spacing: root.title.length > 0 && root.message.length > 0 ? 4 : 0

            Text {
                visible: root.title.length > 0
                width: parent.width
                text: root.title
                color: root.titleColor
                font.pixelSize: 14
                font.bold: true
                wrapMode: Text.WordWrap
                maximumLineCount: root.maxTitleLines
                elide: Text.ElideRight
            }

            Text {
                visible: root.message.length > 0
                width: parent.width
                text: root.message
                color: root.messageColor
                font.pixelSize: 12
                wrapMode: Text.WordWrap
                maximumLineCount: root.maxMessageLines
                elide: Text.ElideRight
            }
        }

        Item {
            visible: root.closable
            width: 20
            height: 20
            anchors.verticalCenter: parent.verticalCenter

            Rectangle {
                anchors.fill: parent
                radius: 10
                color: closeMouse.containsMouse ? Qt.rgba(0, 0, 0, 0.08) : "transparent"
            }

            Text {
                anchors.centerIn: parent
                text: "x"
                color: root.messageColor
                font.pixelSize: 13
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            MouseArea {
                id: closeMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: root.close()
            }
        }
    }
}
