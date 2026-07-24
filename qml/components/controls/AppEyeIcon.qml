import QtQuick
import QtQuick.Shapes

Item {
    id: root

    property bool crossed: false
    property color color: "#6B7280"
    property real strokeWidth: 1.6

    implicitWidth: 18
    implicitHeight: 18

    Shape {
        anchors.fill: parent
        antialiasing: true

        ShapePath {
            fillColor: "transparent"
            strokeColor: root.color
            strokeWidth: root.strokeWidth
            capStyle: ShapePath.RoundCap
            joinStyle: ShapePath.RoundJoin

            PathMove {
                x: root.width * 0.08
                y: root.height * 0.50
            }

            PathQuad {
                x: root.width * 0.92
                y: root.height * 0.50
                controlX: root.width * 0.50
                controlY: root.height * 0.16
            }

            PathQuad {
                x: root.width * 0.08
                y: root.height * 0.50
                controlX: root.width * 0.50
                controlY: root.height * 0.84
            }
        }

        ShapePath {
            fillColor: "transparent"
            strokeColor: root.crossed ? root.color : "transparent"
            strokeWidth: root.crossed ? root.strokeWidth : 0
            capStyle: ShapePath.RoundCap
            joinStyle: ShapePath.RoundJoin

            PathMove {
                x: root.width * 0.83
                y: root.height * 0.17
            }

            PathLine {
                x: root.width * 0.17
                y: root.height * 0.83
            }
        }
    }

    Rectangle {
        visible: !root.crossed
        width: root.width * 0.28
        height: width
        radius: width / 2
        anchors.centerIn: parent
        color: root.color
    }
}
