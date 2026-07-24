import QtQuick
import QtQuick.Controls.Basic as Basic
import QtQuick.Layouts
import "../controls"
import "../theme"

Basic.Popup {
    id: root

    property string title: ""
    property string subtitle: ""
    property bool showIcon: true
    property string iconText: "!"
    property color iconColor: theme.textOnPrimary
    property color iconBackgroundColor: theme.warning
    property int iconSize: 16
    property int preferredWidth: 320
    property int minDialogWidth: 240
    property int maxDialogWidth: 520
    property int screenMargin: theme.dialogMargin
    property bool showCloseButton: true
    property bool closeOnPressOutside: true
    property bool draggable: true
    property bool resetPositionOnOpen: true
    property bool actionHandled: false
    default property alias bodyData: bodySlot.data
    property alias footerData: footerSlot.data

    readonly property real overlayWidth: parent && parent.width > 0 ? parent.width : naturalWidth + screenMargin * 2
    readonly property real overlayHeight: parent && parent.height > 0 ? parent.height : naturalHeight + screenMargin * 2
    readonly property int naturalWidth: Math.max(minDialogWidth, Math.min(preferredWidth, maxDialogWidth))
    readonly property real naturalHeight: Math.max(1, panelLayout.implicitHeight + 28)
    readonly property real widthScale: Math.max(0.35, (overlayWidth - screenMargin * 2) / naturalWidth)
    readonly property real heightScale: Math.max(0.35, (overlayHeight - screenMargin * 2) / naturalHeight)
    readonly property real contentScale: Math.min(1, widthScale, heightScale)
    readonly property real visualWidth: naturalWidth * contentScale
    readonly property real visualHeight: naturalHeight * contentScale

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

    AppTheme {
        id: theme
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

    onOverlayWidthChanged: {
        if (opened)
            clampPanelPosition();
    }

    onOverlayHeightChanged: {
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
                color: theme.textPrimary
                opacity: 0.08
            }

            Rectangle {
                id: panel
                width: root.naturalWidth
                height: root.naturalHeight
                color: theme.panel
                radius: theme.dialogRadius
                border.color: theme.borderLight
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
                    spacing: theme.spacingMedium

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
                                visible: root.showIcon
                                Layout.preferredWidth: root.iconSize
                                Layout.preferredHeight: root.iconSize
                                Layout.alignment: Qt.AlignTop
                                radius: root.iconSize / 2
                                color: root.iconBackgroundColor

                                Text {
                                    anchors.centerIn: parent
                                    text: root.iconText
                                    color: root.iconColor
                                    font.pixelSize: Math.max(10, root.iconSize - 5)
                                    font.bold: true
                                }
                            }

                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: root.subtitle.length > 0 ? 4 : 0

                                Text {
                                    Layout.fillWidth: true
                                    text: root.title
                                    color: theme.textPrimary
                                    font.pixelSize: root.iconSize > 20 ? 16 : 13
                                    font.bold: true
                                    wrapMode: Text.WordWrap
                                }

                                Text {
                                    Layout.fillWidth: true
                                    visible: root.subtitle.length > 0
                                    text: root.subtitle
                                    color: theme.textSecondary
                                    font.pixelSize: 12
                                    wrapMode: Text.WordWrap
                                }
                            }

                            AppIconButton {
                                visible: root.showCloseButton
                                Layout.preferredWidth: 24
                                Layout.preferredHeight: 24
                                Layout.alignment: Qt.AlignTop
                                size: 24
                                onClicked: root.closeAsDismissed()
                            }
                        }
                    }

                    ColumnLayout {
                        id: bodySlot
                        Layout.fillWidth: true
                        visible: children.length > 0
                        spacing: theme.spacingSmall
                    }

                    Item {
                        Layout.fillHeight: true
                    }

                    RowLayout {
                        id: footerSlot
                        Layout.alignment: Qt.AlignRight
                        visible: children.length > 0
                        spacing: theme.spacingSmall
                    }
                }
            }
        }
    }
}