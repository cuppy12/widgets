import QtQuick
import "../theme"

Item {
    id: root

    enum Status {
        Normal,
        Success,
        Warning,
        Error
    }

    property real minimum: 0
    property real maximum: 100
    property real value: 0
    property bool indeterminate: false
    property bool animated: true
    property bool striped: false
    property bool showText: true
    property string label: ""
    property string suffix: "%"
    property int barHeight: 8
    property int textWidth: 42
    property color trackColor: theme.track
    property color progressColor: theme.primary
    property color successColor: theme.success
    property color warningColor: theme.warning
    property color errorColor: theme.danger
    property color textColor: "#374151"
    property int status: AppProgressBar.Normal

    readonly property real range: Math.max(0.0001, maximum - minimum)
    readonly property real normalizedValue: Math.max(0, Math.min(1, (value - minimum) / range))
    readonly property int percent: Math.round(normalizedValue * 100)
    readonly property color fillColor: status === AppProgressBar.Success
                                      ? successColor
                                      : (status === AppProgressBar.Warning
                                         ? warningColor
                                         : (status === AppProgressBar.Error ? errorColor : progressColor))

    implicitWidth: 260
    implicitHeight: Math.max(barHeight, showText ? 18 : barHeight)

    AppTheme {
        id: theme
    }

    TextMetrics {
        id: labelMetrics
        text: root.label
        font.pixelSize: 12
    }

    Row {
        anchors.fill: parent
        spacing: showText ? 8 : 0

        Text {
            id: labelText
            visible: root.label.length > 0
            width: visible ? labelMetrics.advanceWidth : 0
            anchors.verticalCenter: parent.verticalCenter
            text: root.label
            color: root.textColor
            font.pixelSize: 12
            elide: Text.ElideRight
        }

        Rectangle {
            id: track
            width: Math.max(0, parent.width - labelText.width - valueText.width - parent.spacing * (root.showText ? 2 : 1))
            height: root.barHeight
            anchors.verticalCenter: parent.verticalCenter
            radius: height / 2
            color: root.trackColor
            clip: true

            Rectangle {
                id: fill
                height: parent.height
                radius: parent.radius
                color: root.fillColor
                width: root.indeterminate ? Math.max(36, parent.width * 0.32) : parent.width * root.normalizedValue
                x: root.indeterminate ? indeterminateDriver.xPosition : 0

                Behavior on width {
                    enabled: root.animated && !root.indeterminate
                    NumberAnimation {
                        duration: 180
                        easing.type: Easing.OutCubic
                    }
                }

                Repeater {
                    model: root.striped ? Math.ceil(track.width / 12) + 4 : 0

                    Rectangle {
                        width: 6
                        height: track.height * 2
                        x: index * 12 + stripeDriver.offset - 24
                        y: -track.height / 2
                        rotation: 25
                        color: "#FFFFFF"
                        opacity: 0.22
                    }
                }
            }
        }

        Text {
            id: valueText
            visible: root.showText
            width: visible ? root.textWidth : 0
            anchors.verticalCenter: parent.verticalCenter
            text: root.indeterminate ? "..." : root.percent + root.suffix
            color: root.textColor
            font.pixelSize: 12
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
        }
    }

    QtObject {
        id: indeterminateDriver
        property real xPosition: -fill.width
    }

    SequentialAnimation {
        running: root.indeterminate && root.visible
        loops: Animation.Infinite

        NumberAnimation {
            target: indeterminateDriver
            property: "xPosition"
            from: -fill.width
            to: track.width
            duration: 1200
            easing.type: Easing.InOutCubic
        }
    }

    QtObject {
        id: stripeDriver
        property real offset: 0
    }

    NumberAnimation {
        target: stripeDriver
        property: "offset"
        from: 0
        to: 12
        duration: 500
        loops: Animation.Infinite
        running: root.striped && root.visible
    }
}