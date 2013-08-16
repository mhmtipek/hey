// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0

Rectangle {
    id: header

    height: 70

    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right

    color: "red"

    property string title: ""

    Label {
        y: (parent.height - height) / 2

        anchors.left: parent.left
        anchors.leftMargin: 25
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft

        text: title
        font.pixelSize: 32
        font.bold: false
        color: "white"
    }
}
