import QtQuick
import QtQuick.Controls.Basic as Basic
import QtQuick.Layouts

Flickable {
    id: root

    default property alias contentData: pageContent.data

    clip: true
    contentWidth: width
    contentHeight: pageContent.implicitHeight
    boundsBehavior: Flickable.StopAtBounds

    ColumnLayout {
        id: pageContent
        width: root.width
        spacing: 16
    }

    Basic.ScrollBar.vertical: Basic.ScrollBar {
        policy: root.contentHeight > root.height ? Basic.ScrollBar.AlwaysOn : Basic.ScrollBar.AsNeeded
    }
}
