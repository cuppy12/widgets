import QtQuick
import QtQuick.Layouts
import "../components/theme"

Rectangle {
    id: root

    property string title: ""
    property string badgeText: ""
    property string description: ""
    property int contentMargin: 18
    property int minimumPanelHeight: 180
    default property alias contentData: contentSlot.data

    Layout.fillWidth: true
    Layout.minimumHeight: minimumPanelHeight
    implicitHeight: Math.max(minimumPanelHeight, panelLayout.implicitHeight + contentMargin * 2)
    radius: theme.dialogRadius
    color: theme.panel
    border.color: theme.borderLight
    border.width: 1

    AppTheme {
        id: theme
    }

    ColumnLayout {
        id: panelLayout
        anchors.fill: parent
        anchors.margins: root.contentMargin
        spacing: 14

        RowLayout {
            Layout.fillWidth: true
            spacing: 10

            Text {
                Layout.fillWidth: true
                text: root.title
                color: theme.textPrimary
                font.pixelSize: 17
                font.bold: true
                elide: Text.ElideRight
            }

            Rectangle {
                visible: root.badgeText.length > 0
                Layout.preferredHeight: 24
                Layout.minimumWidth: badgeLabel.implicitWidth + 18
                radius: 12
                color: theme.primarySoft

                Text {
                    id: badgeLabel
                    anchors.centerIn: parent
                    text: root.badgeText
                    color: theme.primaryPressed
                    font.pixelSize: 12
                    font.bold: true
                }
            }
        }

        Text {
            Layout.fillWidth: true
            visible: root.description.length > 0
            text: root.description
            color: theme.textMuted
            font.pixelSize: 13
            lineHeight: 1.18
            wrapMode: Text.WordWrap
        }

        ColumnLayout {
            id: contentSlot
            Layout.fillWidth: true
            spacing: 12
        }
    }
}
