// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0

Rectangle {
    id: completer

    anchors.top: parent.bottom
    anchors.left: parent.left

    width: parent.width + border.width
//    height: itemHeight * model.count + 2 * listView.anchors.margins + border.width

    clip: true

    property alias model: listView.model
    property int itemHeight: 55

    signal textSelected(string text)

    radius: 16

    color: "#F9F9F9"
    border.color: "#CACACA"

    ListView {
        id: listView

        anchors.fill: parent
        anchors.margins: 3

        clip: true

        delegate: Rectangle {
            width: parent.width
            height: itemHeight

            property color defaultColor: "#F9F9F9"
            property color highlightColor: "red"
            color: defaultColor

            Label {
                id: suggestionText

                anchors.fill: parent
                anchors.leftMargin: 15

                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter

                text: suggestion
            }

            MouseArea {
                anchors.fill: parent

                onPressed: parent.color = parent.highlightColor
                onReleased: parent.color = parent.defaultColor
                onCanceled: parent.color = parent.defaultColor

                onClicked: {
                    completer.textSelected(suggestionText.text);
                }
            }
        }
    }
}
