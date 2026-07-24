import QtQuick
import QtQuick.Layouts
import "../theme"

Item {
    id: root

    property string currentLanguage: "zh_CN"
    property var languages: [
        { "code": "zh_CN", "label": "中文" },
        { "code": "en_US", "label": "EN" }
    ]
    property string label: ""

    signal languageSelected(string language)

    implicitWidth: switchLayout.implicitWidth
    implicitHeight: 32

    AppTheme {
        id: theme
    }

    RowLayout {
        id: switchLayout
        anchors.fill: parent
        spacing: 8

        Text {
            visible: root.label.length > 0
            text: root.label
            color: theme.textMuted
            font.pixelSize: 12
            verticalAlignment: Text.AlignVCenter
        }

        Rectangle {
            Layout.preferredWidth: optionsRow.implicitWidth + 4
            Layout.preferredHeight: 32
            radius: theme.radiusMedium
            color: theme.panel
            border.color: theme.borderLight
            border.width: 1

            Row {
                id: optionsRow
                anchors.centerIn: parent
                spacing: 2

                Repeater {
                    model: root.languages

                    delegate: Rectangle {
                        width: Math.max(44, optionText.implicitWidth + 18)
                        height: 26
                        radius: theme.radiusSmall
                        color: modelData.code === root.currentLanguage
                               ? theme.primary
                               : (optionMouse.containsMouse ? theme.hoverLight : "transparent")

                        Text {
                            id: optionText
                            anchors.centerIn: parent
                            text: modelData.label
                            color: modelData.code === root.currentLanguage ? theme.textOnPrimary : theme.textSecondary
                            font.pixelSize: 12
                            font.bold: modelData.code === root.currentLanguage
                        }

                        MouseArea {
                            id: optionMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: root.languageSelected(modelData.code)
                        }
                    }
                }
            }
        }
    }
}
