import QtQuick
import QtQuick.Controls.Basic as Basic
import QtQuick.Layouts

Basic.Popup {
    id: root

    property string dialogTitle: "提示"
    property string message: ""
    property string confirmText: "确认"
    property string cancelText: "取消"
    property int preferredWidth: 320
    property int minDialogWidth: 240
    property int maxDialogWidth: 520
    property int screenMargin: 24
    property bool showCloseButton: true
    property bool closeOnPressOutside: true
    property bool draggable: true
    property bool resetPositionOnOpen: true
    property bool actionHandled: false
    default property alias dialogContent: customContent.data

    readonly property real overlayWidth: parent && parent.width > 0 ? parent.width : naturalWidth + screenMargin * 2
    readonly property real overlayHeight: parent && parent.height > 0 ? parent.height : naturalHeight + screenMargin * 2
    readonly property int naturalWidth: Math.max(minDialogWidth, Math.min(preferredWidth, maxDialogWidth))
    readonly property real naturalHeight: Math.max(1, panelLayout.implicitHeight + 28)
    readonly property real widthScale: Math.max(0.35, (overlayWidth - screenMargin * 2) / naturalWidth)
    readonly property real heightScale: Math.max(0.35, (overlayHeight - screenMargin * 2) / naturalHeight)
    readonly property real contentScale: Math.min(1, widthScale, heightScale)
    readonly property real visualWidth: naturalWidth * contentScale
    readonly property real visualHeight: naturalHeight * contentScale

    signal confirmed()
    signal denied()
    signal dismissed()

    function centerPanel() {
        scaledHost.x = Math.round((overlayWidth - visualWidth) / 2);
        scaledHost.y = Math.round((overlayHeight - visualHeight) / 2);
    }

    function clampPanelPosition() {
        const maxX = Math.max(screenMargin, overlayWidth - visualWidth - screenMargin);
        const maxY = Math.max(screenMargin, overlayHeight - visualHeight - screenMargin);
        scaledHost.x = Math.max(screenMargin, Math.min(scaledHost.x, maxX));
        scaledHost.y = Math.max(screenMargin, Math.min(scaledHost.y, maxY));
    }

    function closeAsDismissed() {
        actionHandled = true;
        dismissed();
        close();
    }

    modal: false
    focus: true
    closePolicy: Basic.Popup.CloseOnEscape
    padding: 0
    dim: false
    x: 0
    y: 0
    width: overlayWidth
    height: overlayHeight

    onOpened: {
        actionHandled = false;
        if (resetPositionOnOpen)
            centerPanel();
        else
            clampPanelPosition();
    }

    onContentScaleChanged: {
        if (opened)
            clampPanelPosition();
    }

    onNaturalHeightChanged: {
        if (opened)
            clampPanelPosition();
    }

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

        MouseArea {
            anchors.fill: parent
            enabled: root.closeOnPressOutside

            onClicked: root.closeAsDismissed()
        }

        Item {
            id: scaledHost
            width: root.naturalWidth
            height: root.naturalHeight
            transformOrigin: Item.TopLeft
            scale: root.contentScale

            Rectangle {
                anchors.fill: panel
                anchors.topMargin: 3
                radius: panel.radius
                color: "#111827"
                opacity: 0.08
            }

            Rectangle {
                id: panel
                width: root.naturalWidth
                height: root.naturalHeight
                color: "#FFFFFF"
                radius: 8
                border.color: "#E5E7EB"
                border.width: 1
                clip: true

                MouseArea {
                    anchors.fill: parent
                }

                ColumnLayout {
                    id: panelLayout
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.margins: 14
                    spacing: 12

                    Item {
                        id: header
                        Layout.fillWidth: true
                        implicitHeight: headerLayout.implicitHeight

                        MouseArea {
                            id: dragMouse
                            anchors.fill: parent
                            enabled: root.draggable
                            hoverEnabled: root.draggable
                            cursorShape: root.draggable ? Qt.SizeAllCursor : Qt.ArrowCursor
                            drag.target: root.draggable ? scaledHost : null
                            drag.axis: Drag.XAndYAxis
                            drag.minimumX: root.screenMargin
                            drag.maximumX: Math.max(root.screenMargin, root.overlayWidth - root.visualWidth - root.screenMargin)
                            drag.minimumY: root.screenMargin
                            drag.maximumY: Math.max(root.screenMargin, root.overlayHeight - root.visualHeight - root.screenMargin)
                        }

                        RowLayout {
                            id: headerLayout
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.top: parent.top
                            spacing: 10

                            Rectangle {
                                Layout.preferredWidth: 16
                                Layout.preferredHeight: 16
                                Layout.alignment: Qt.AlignTop
                                radius: 8
                                color: "#FAAD14"

                                Text {
                                    anchors.centerIn: parent
                                    text: "!"
                                    color: "#FFFFFF"
                                    font.pixelSize: 11
                                    font.bold: true
                                }
                            }

                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: root.message.length > 0 ? 4 : 0

                                Text {
                                    Layout.fillWidth: true
                                    text: root.dialogTitle
                                    color: "#111827"
                                    font.pixelSize: 13
                                    font.bold: true
                                    wrapMode: Text.WordWrap
                                }

                                Text {
                                    Layout.fillWidth: true
                                    visible: root.message.length > 0
                                    text: root.message
                                    color: "#4B5563"
                                    font.pixelSize: 12
                                    wrapMode: Text.WordWrap
                                }
                            }

                            Rectangle {
                                visible: root.showCloseButton
                                Layout.preferredWidth: 22
                                Layout.preferredHeight: 22
                                Layout.alignment: Qt.AlignTop
                                radius: 11
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

                                    onClicked: root.closeAsDismissed()
                                }
                            }
                        }
                    }

                    Column {
                        id: customContent
                        Layout.fillWidth: true
                        visible: children.length > 0
                        spacing: 8
                    }

                    Item {
                        Layout.fillHeight: true
                    }

                    RowLayout {
                        Layout.alignment: Qt.AlignRight
                        spacing: 8

                        Rectangle {
                            Layout.preferredWidth: Math.max(56, cancelTextItem.implicitWidth + 20)
                            Layout.preferredHeight: 28
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

                                onClicked: {
                                    root.actionHandled = true;
                                    root.denied();
                                    root.close();
                                }
                            }
                        }

                        Rectangle {
                            Layout.preferredWidth: Math.max(56, confirmTextItem.implicitWidth + 20)
                            Layout.preferredHeight: 28
                            radius: 4
                            color: confirmMouse.pressed ? "#0958D9" : (confirmMouse.containsMouse ? "#4096FF" : "#1677FF")

                            Text {
                                id: confirmTextItem
                                anchors.centerIn: parent
                                text: root.confirmText
                                color: "#FFFFFF"
                                font.pixelSize: 12
                            }

                            MouseArea {
                                id: confirmMouse
                                anchors.fill: parent
                                hoverEnabled: true

                                onClicked: {
                                    root.actionHandled = true;
                                    root.confirmed();
                                    root.close();
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
