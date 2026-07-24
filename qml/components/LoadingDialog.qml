import QtQuick
import QtQuick.Controls.Basic as Basic
import QtQuick.Layouts

Basic.Popup {
    id: root

    property string dialogTitle: "正在加载"
    property string message: "请稍候，正在处理数据。"
    property string detailText: ""
    property string cancelText: "取消"
    property real progress: -1
    property bool showCloseButton: true
    property bool showCancelButton: false
    property bool closeOnPressOutside: false
    property int preferredWidth: 300
    property int minDialogWidth: 220
    property int maxDialogWidth: 360
    property int screenMargin: 24
    property bool actionHandled: false

    readonly property int naturalWidth: Math.max(minDialogWidth, Math.min(preferredWidth, maxDialogWidth))
    readonly property real overlayWidth: parent && parent.width > 0 ? parent.width : naturalWidth + screenMargin * 2
    readonly property real overlayHeight: parent && parent.height > 0 ? parent.height : naturalHeight + screenMargin * 2
    readonly property real naturalHeight: Math.max(1, panel.implicitHeight)
    readonly property real widthScale: Math.max(0.35, (overlayWidth - screenMargin * 2) / naturalWidth)
    readonly property real heightScale: Math.max(0.35, (overlayHeight - screenMargin * 2) / naturalHeight)
    readonly property real contentScale: Math.min(1, widthScale, heightScale)
    readonly property real normalizedProgress: Math.max(0, Math.min(1, progress))
    readonly property bool hasProgress: progress >= 0

    signal cancelled()
    signal dismissed()

    function cancel() {
        root.actionHandled = true;
        root.cancelled();
        root.close();
    }

    modal: true
    focus: true
    closePolicy: closeOnPressOutside
                 ? (Basic.Popup.CloseOnEscape | Basic.Popup.CloseOnPressOutside)
                 : Basic.Popup.CloseOnEscape
    padding: 0
    dim: true
    width: Math.round(naturalWidth * contentScale)
    height: Math.round(naturalHeight * contentScale)

    x: Math.round((overlayWidth - width) / 2)
    y: Math.round((overlayHeight - height) / 2)

    onOpened: actionHandled = false

    onClosed: {
        if (!actionHandled)
            root.dismissed();
    }

    background: Item {
    }

    contentItem: Item {
        implicitWidth: root.width
        implicitHeight: root.height
        clip: false

        Item {
            width: root.naturalWidth
            height: root.naturalHeight
            transformOrigin: Item.TopLeft
            scale: root.contentScale

            Rectangle {
                anchors.fill: panel
                anchors.topMargin: 4
                radius: panel.radius
                color: "#111827"
                opacity: 0.10
            }

            Rectangle {
                id: panel
                width: root.naturalWidth
                implicitHeight: panelLayout.implicitHeight + 32
                color: "#FFFFFF"
                radius: 8
                border.color: "#E5E7EB"
                border.width: 1

                ColumnLayout {
                    id: panelLayout
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.margins: 16
                    spacing: 14

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 10

                        Item {
                            id: spinner
                            Layout.preferredWidth: 42
                            Layout.preferredHeight: 42
                            Layout.alignment: Qt.AlignTop

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
                                    width: 5
                                    height: 5
                                    radius: 2.5
                                    color: "#1677FF"
                                    opacity: 0.20 + index * 0.06
                                    x: spinner.width / 2 - width / 2
                                       + Math.cos((index * 30 - 90) * Math.PI / 180) * 16
                                    y: spinner.height / 2 - height / 2
                                       + Math.sin((index * 30 - 90) * Math.PI / 180) * 16
                                }
                            }
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 5

                            Text {
                                Layout.fillWidth: true
                                text: root.dialogTitle
                                color: "#111827"
                                font.pixelSize: 16
                                font.bold: true
                                wrapMode: Text.WordWrap
                            }

                            Text {
                                Layout.fillWidth: true
                                text: root.message
                                color: "#4B5563"
                                font.pixelSize: 12
                                wrapMode: Text.WordWrap
                            }

                            Text {
                                Layout.fillWidth: true
                                visible: root.detailText.length > 0
                                text: root.detailText
                                color: "#6B7280"
                                font.pixelSize: 11
                                wrapMode: Text.WordWrap
                            }
                        }

                        Rectangle {
                            visible: root.showCloseButton
                            Layout.preferredWidth: 24
                            Layout.preferredHeight: 24
                            Layout.alignment: Qt.AlignTop
                            radius: 12
                            color: closeMouse.containsMouse ? "#F3F4F6" : "transparent"

                            Text {
                                anchors.centerIn: parent
                                text: "×"
                                color: "#6B7280"
                                font.pixelSize: 18
                                lineHeight: 0.8
                            }

                            MouseArea {
                                id: closeMouse
                                anchors.fill: parent
                                hoverEnabled: true

                                onClicked: root.cancel()
                            }
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 6
                        visible: root.hasProgress
                        radius: 3
                        color: "#E5E7EB"

                        Rectangle {
                            anchors.left: parent.left
                            anchors.top: parent.top
                            anchors.bottom: parent.bottom
                            width: parent.width * root.normalizedProgress
                            radius: parent.radius
                            color: "#1677FF"
                        }
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        visible: root.showCancelButton

                        Item {
                            Layout.fillWidth: true
                        }

                        Rectangle {
                            Layout.preferredWidth: Math.max(62, cancelTextItem.implicitWidth + 24)
                            Layout.preferredHeight: 30
                            radius: 4
                            color: cancelMouse.containsMouse ? "#F9FAFB" : "#FFFFFF"
                            border.color: "#D1D5DB"
                            border.width: 1

                            Text {
                                id: cancelTextItem
                                anchors.centerIn: parent
                                text: root.cancelText
                                color: "#374151"
                                font.pixelSize: 12
                            }

                            MouseArea {
                                id: cancelMouse
                                anchors.fill: parent
                                hoverEnabled: true

                                onClicked: root.cancel()
                            }
                        }
                    }
                }
            }
        }
    }
}
