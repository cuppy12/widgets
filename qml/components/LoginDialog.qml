import QtQuick
import QtQuick.Controls.Basic as Basic
import QtQuick.Layouts

Basic.Popup {
    id: root

    property string dialogTitle: "用户登录"
    property string subtitle: "请输入账号和密码"
    property alias username: usernameInput.text
    property alias password: passwordInput.text
    property string usernamePlaceholder: "用户名"
    property string passwordPlaceholder: "密码"
    property string loginText: "登录"
    property string cancelText: "取消"
    property string errorText: ""
    property alias rememberMe: rememberCheck.checked
    property bool showCloseButton: true
    property bool closeOnPressOutside: true
    property bool draggable: true
    property bool resetPositionOnOpen: true
    property int preferredWidth: 360
    property int minDialogWidth: 280
    property int maxDialogWidth: 420
    property int screenMargin: 24
    property bool actionHandled: false

    readonly property int naturalWidth: Math.max(minDialogWidth, Math.min(preferredWidth, maxDialogWidth))
    readonly property real overlayWidth: parent && parent.width > 0 ? parent.width : naturalWidth + screenMargin * 2
    readonly property real overlayHeight: parent && parent.height > 0 ? parent.height : naturalHeight + screenMargin * 2
    readonly property real naturalHeight: Math.max(1, panel.implicitHeight)
    readonly property real widthScale: Math.max(0.35, (overlayWidth - screenMargin * 2) / naturalWidth)
    readonly property real heightScale: Math.max(0.35, (overlayHeight - screenMargin * 2) / naturalHeight)
    readonly property real contentScale: Math.min(1, widthScale, heightScale)
    readonly property real visualWidth: naturalWidth * contentScale
    readonly property real visualHeight: naturalHeight * contentScale

    signal loginRequested(string username, string password, bool rememberMe)
    signal cancelled()
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

    function clearPassword() {
        passwordInput.text = "";
    }

    function submit() {
        root.actionHandled = true;
        root.loginRequested(usernameInput.text, passwordInput.text, rememberCheck.checked);
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
        usernameInput.forceActiveFocus();
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

                MouseArea {
                    anchors.fill: parent
                }

                ColumnLayout {
                    id: panelLayout
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.margins: 16
                    spacing: 14

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
                                Layout.preferredWidth: 34
                                Layout.preferredHeight: 34
                                radius: 17
                                color: "#EAF2FF"

                                Text {
                                    anchors.centerIn: parent
                                    text: "↪"
                                    color: "#1677FF"
                                    font.pixelSize: 18
                                    font.bold: true
                                }
                            }

                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 2

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
                                    visible: root.subtitle.length > 0
                                    text: root.subtitle
                                    color: "#6B7280"
                                    font.pixelSize: 12
                                    wrapMode: Text.WordWrap
                                }
                            }

                            Rectangle {
                                visible: root.showCloseButton
                                Layout.preferredWidth: 24
                                Layout.preferredHeight: 24
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

                                    onClicked: root.closeAsDismissed()
                                }
                            }
                        }
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 10

                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 36
                            radius: 5
                            color: usernameInput.activeFocus ? "#FFFFFF" : "#F9FAFB"
                            border.color: usernameInput.activeFocus ? "#1677FF" : "#D1D5DB"
                            border.width: 1

                            Text {
                                anchors.left: parent.left
                                anchors.leftMargin: 10
                                anchors.verticalCenter: parent.verticalCenter
                                text: "用户"
                                color: "#6B7280"
                                font.pixelSize: 12
                            }

                            TextInput {
                                id: usernameInput
                                anchors.left: parent.left
                                anchors.leftMargin: 46
                                anchors.right: parent.right
                                anchors.rightMargin: 10
                                anchors.verticalCenter: parent.verticalCenter
                                height: 24
                                clip: true
                                color: "#111827"
                                font.pixelSize: 13
                                selectByMouse: true
                                verticalAlignment: TextInput.AlignVCenter

                                Text {
                                    anchors.fill: parent
                                    visible: usernameInput.text.length === 0 && !usernameInput.activeFocus
                                    text: root.usernamePlaceholder
                                    color: "#9CA3AF"
                                    font: usernameInput.font
                                    verticalAlignment: Text.AlignVCenter
                                }

                                Keys.onReturnPressed: passwordInput.forceActiveFocus()
                                Keys.onEnterPressed: passwordInput.forceActiveFocus()
                            }
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 36
                            radius: 5
                            color: passwordInput.activeFocus ? "#FFFFFF" : "#F9FAFB"
                            border.color: passwordInput.activeFocus ? "#1677FF" : "#D1D5DB"
                            border.width: 1

                            Text {
                                anchors.left: parent.left
                                anchors.leftMargin: 10
                                anchors.verticalCenter: parent.verticalCenter
                                text: "密码"
                                color: "#6B7280"
                                font.pixelSize: 12
                            }

                            TextInput {
                                id: passwordInput
                                anchors.left: parent.left
                                anchors.leftMargin: 46
                                anchors.right: parent.right
                                anchors.rightMargin: 38
                                anchors.verticalCenter: parent.verticalCenter
                                height: 24
                                clip: true
                                color: "#111827"
                                font.pixelSize: 13
                                echoMode: passwordVisible.checked ? TextInput.Normal : TextInput.Password
                                selectByMouse: true
                                verticalAlignment: TextInput.AlignVCenter

                                Text {
                                    anchors.fill: parent
                                    visible: passwordInput.text.length === 0 && !passwordInput.activeFocus
                                    text: root.passwordPlaceholder
                                    color: "#9CA3AF"
                                    font: passwordInput.font
                                    verticalAlignment: Text.AlignVCenter
                                }

                                Keys.onReturnPressed: root.submit()
                                Keys.onEnterPressed: root.submit()
                            }

                            Rectangle {
                                anchors.right: parent.right
                                anchors.rightMargin: 8
                                anchors.verticalCenter: parent.verticalCenter
                                width: 24
                                height: 24
                                radius: 12
                                color: passwordMouse.containsMouse ? "#EEF2FF" : "transparent"

                                Text {
                                    anchors.centerIn: parent
                                    text: passwordVisible.checked ? "明" : "隐"
                                    color: "#6B7280"
                                    font.pixelSize: 11
                                }

                                MouseArea {
                                    id: passwordMouse
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    onClicked: passwordVisible.checked = !passwordVisible.checked
                                }

                                QtObject {
                                    id: passwordVisible
                                    property bool checked: false
                                }
                            }
                        }

                        RowLayout {
                            Layout.fillWidth: true

                            Rectangle {
                                Layout.preferredWidth: 16
                                Layout.preferredHeight: 16
                                radius: 3
                                color: rememberCheck.checked ? "#1677FF" : "#FFFFFF"
                                border.color: rememberCheck.checked ? "#1677FF" : "#D1D5DB"
                                border.width: 1

                                Text {
                                    anchors.centerIn: parent
                                    visible: rememberCheck.checked
                                    text: "✓"
                                    color: "#FFFFFF"
                                    font.pixelSize: 12
                                    font.bold: true
                                }

                                MouseArea {
                                    id: rememberCheck
                                    property bool checked: false
                                    anchors.fill: parent
                                    onClicked: checked = !checked
                                }
                            }

                            Text {
                                text: "记住登录"
                                color: "#4B5563"
                                font.pixelSize: 12

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: rememberCheck.checked = !rememberCheck.checked
                                }
                            }

                            Item {
                                Layout.fillWidth: true
                            }
                        }

                        Text {
                            Layout.fillWidth: true
                            visible: root.errorText.length > 0
                            text: root.errorText
                            color: "#DC2626"
                            font.pixelSize: 12
                            wrapMode: Text.WordWrap
                        }
                    }

                    RowLayout {
                        Layout.alignment: Qt.AlignRight
                        spacing: 8

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

                                onClicked: {
                                    root.actionHandled = true;
                                    root.cancelled();
                                    root.close();
                                }
                            }
                        }

                        Rectangle {
                            Layout.preferredWidth: Math.max(78, loginTextItem.implicitWidth + 28)
                            Layout.preferredHeight: 30
                            radius: 4
                            color: loginMouse.pressed ? "#0958D9" : (loginMouse.containsMouse ? "#4096FF" : "#1677FF")

                            Text {
                                id: loginTextItem
                                anchors.centerIn: parent
                                text: root.loginText
                                color: "#FFFFFF"
                                font.pixelSize: 12
                            }

                            MouseArea {
                                id: loginMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                onClicked: root.submit()
                            }
                        }
                    }
                }
            }
        }
    }
}
