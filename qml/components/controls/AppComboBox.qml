pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls.Basic as Basic
import "../theme"

Item {
    id: root

    property var model: []
    property int currentIndex: 0
    property string label: ""
    property string placeholderText: "Select"
    property string emptyText: "No options"
    property bool expanded: false
    property bool enabled: true
    property int maxVisibleItems: 5
    property int itemHeight: 36
    property int highlightedIndex: currentIndex

    readonly property int modelCount: model && model.count !== undefined
                                      ? model.count
                                      : (model && model.length !== undefined ? model.length : 0)
    readonly property string currentText: resolveText(currentIndex)
    readonly property int popupHeight: modelCount > 0
                                       ? Math.min(maxVisibleItems, modelCount) * itemHeight
                                       : itemHeight

    signal activated(int index, string text)

    function itemAt(index) {
        if (index < 0 || index >= modelCount)
            return null;
        if (model && model.get !== undefined)
            return model.get(index);
        return model[index];
    }

    function textFromItem(item) {
        if (item === null || item === undefined)
            return "";
        if (typeof item === "string" || typeof item === "number")
            return String(item);
        if (item.text !== undefined)
            return String(item.text);
        if (item.label !== undefined)
            return String(item.label);
        if (item.name !== undefined)
            return String(item.name);
        if (item.username !== undefined)
            return String(item.username);
        if (item.value !== undefined)
            return String(item.value);
        return "";
    }

    function resolveText(index) {
        return textFromItem(itemAt(index));
    }

    function clampCurrentIndex() {
        if (modelCount <= 0) {
            currentIndex = -1;
            highlightedIndex = -1;
            return;
        }

        if (currentIndex < 0 || currentIndex >= modelCount)
            currentIndex = 0;
        highlightedIndex = currentIndex;
    }

    function openPopup() {
        if (!enabled)
            return;
        clampCurrentIndex();
        expanded = true;
        forceActiveFocus();
        listView.positionViewAtIndex(Math.max(0, highlightedIndex), ListView.Contain);
    }

    function closePopup() {
        expanded = false;
    }

    function togglePopup() {
        if (expanded)
            closePopup();
        else
            openPopup();
    }

    function selectIndex(index) {
        if (index < 0 || index >= modelCount)
            return;
        currentIndex = index;
        highlightedIndex = index;
        closePopup();
        activated(index, currentText);
    }

    function forceInputFocus() {
        forceActiveFocus();
    }

    implicitWidth: 260
    implicitHeight: theme.fieldHeight + (expanded ? popupHeight + 6 : 0)
    opacity: enabled ? 1.0 : 0.55
    z: expanded ? 10 : 0
    focus: true

    onModelChanged: clampCurrentIndex()
    onModelCountChanged: clampCurrentIndex()
    onActiveFocusChanged: {
        if (!activeFocus)
            closePopup();
    }

    Keys.onPressed: function(event) {
        if (!root.enabled)
            return;

        if (event.key === Qt.Key_Space || event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
            if (root.expanded)
                root.selectIndex(root.highlightedIndex);
            else
                root.openPopup();
            event.accepted = true;
        } else if (event.key === Qt.Key_Down) {
            if (!root.expanded)
                root.openPopup();
            else
                root.highlightedIndex = Math.min(root.modelCount - 1, root.highlightedIndex + 1);
            listView.positionViewAtIndex(Math.max(0, root.highlightedIndex), ListView.Contain);
            event.accepted = true;
        } else if (event.key === Qt.Key_Up) {
            if (root.expanded) {
                root.highlightedIndex = Math.max(0, root.highlightedIndex - 1);
                listView.positionViewAtIndex(Math.max(0, root.highlightedIndex), ListView.Contain);
                event.accepted = true;
            }
        } else if (event.key === Qt.Key_Escape && root.expanded) {
            root.closePopup();
            event.accepted = true;
        }
    }

    AppTheme {
        id: theme
    }

    TextMetrics {
        id: labelMetrics
        text: root.label
        font.pixelSize: 12
    }

    Rectangle {
        id: fieldFrame
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        height: theme.fieldHeight
        radius: theme.radiusMedium
        color: root.activeFocus || root.expanded ? theme.panel : theme.fieldIdle
        border.color: root.activeFocus || root.expanded ? theme.primary : theme.border
        border.width: 1

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

        Text {
            anchors.left: parent.left
            anchors.leftMargin: root.label.length > 0 ? labelText.width + 20 : 10
            anchors.right: chevron.left
            anchors.rightMargin: 8
            anchors.verticalCenter: parent.verticalCenter
            text: root.currentText.length > 0 ? root.currentText : root.placeholderText
            color: root.currentText.length > 0 ? theme.textPrimary : theme.textPlaceholder
            font.pixelSize: 13
            elide: Text.ElideRight
            verticalAlignment: Text.AlignVCenter
        }

        Item {
            id: chevron
            anchors.right: parent.right
            anchors.rightMargin: 12
            anchors.verticalCenter: parent.verticalCenter
            width: 16
            height: 16

            Rectangle {
                width: 7
                height: 2
                radius: 1
                x: 3
                y: 7
                rotation: root.expanded ? -45 : 45
                color: theme.textMuted
            }

            Rectangle {
                width: 7
                height: 2
                radius: 1
                x: 7
                y: 7
                rotation: root.expanded ? 45 : -45
                color: theme.textMuted
            }
        }

        MouseArea {
            anchors.fill: parent
            enabled: root.enabled
            hoverEnabled: true
            cursorShape: root.enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
            onClicked: root.togglePopup()
        }
    }

    Rectangle {
        id: popupPanel
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: fieldFrame.bottom
        anchors.topMargin: 6
        height: root.popupHeight
        visible: root.expanded
        radius: theme.radiusMedium
        color: theme.panel
        border.color: theme.borderLight
        border.width: 1
        clip: true

        ListView {
            id: listView
            anchors.fill: parent
            visible: root.modelCount > 0
            clip: true
            model: root.model
            boundsBehavior: Flickable.StopAtBounds
            currentIndex: root.highlightedIndex

            delegate: Item {
                id: optionDelegate

                required property int index

                width: ListView.view.width
                height: root.itemHeight

                readonly property string optionText: root.resolveText(optionDelegate.index)
                readonly property bool selected: optionDelegate.index === root.currentIndex
                readonly property bool highlighted: optionDelegate.index === root.highlightedIndex

                Rectangle {
                    anchors.fill: parent
                    anchors.margins: 2
                    radius: theme.radiusSmall
                    color: optionDelegate.selected ? theme.primarySoft : (optionDelegate.highlighted ? theme.hoverLight : "transparent")
                }

                Text {
                    anchors.left: parent.left
                    anchors.leftMargin: 12
                    anchors.right: parent.right
                    anchors.rightMargin: 12
                    anchors.verticalCenter: parent.verticalCenter
                    text: optionDelegate.optionText
                    color: optionDelegate.selected ? theme.primaryPressed : theme.textPrimary
                    font.pixelSize: 13
                    font.bold: optionDelegate.selected
                    elide: Text.ElideRight
                    verticalAlignment: Text.AlignVCenter
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onEntered: root.highlightedIndex = optionDelegate.index
                    onClicked: root.selectIndex(optionDelegate.index)
                }
            }

            Basic.ScrollBar.vertical: Basic.ScrollBar {
                policy: listView.contentHeight > listView.height ? Basic.ScrollBar.AlwaysOn : Basic.ScrollBar.AsNeeded
            }
        }

        Text {
            anchors.fill: parent
            visible: root.modelCount === 0
            text: root.emptyText
            color: theme.textPlaceholder
            font.pixelSize: 13
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }
    }
}
