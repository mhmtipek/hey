// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0

Rectangle {
    id: ratingRect

    height: likesCountLabel.height + graph.height

    property int likesCount: 0
    property int dislikesCount: 0

    color: "transparent"

    function fixText(val) {
        if (val == -1)
            return "-";
        else
            return "" + val;
    }

    Label {
        id: likesCountLabel

        anchors.left: parent.left
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter

        text: fixText(likesCount);
        font.pixelSize: 22
        color: likesCount == -1 ? "darkgray" : "green"
    }

    Label {
        id: dislikesCountLabel

        anchors.right: parent.right
        horizontalAlignment: Text.AlignRight
        verticalAlignment: Text.AlignVCenter

        text: fixText(dislikesCount);
        font.pixelSize: 22
        color: dislikesCount == -1 ? "darkgray" : "red"
    }

    Rectangle {
        id: graph

        anchors.top: likesCountLabel.bottom
        width: parent.width
        height: 5

        Rectangle {
            id: likesRect

            width: parent.width * (likesCount / (likesCount + dislikesCount));

            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom

            color: likesCount == -1 || dislikesCount == -1 ? "darkgray" : "green"
        }

        Rectangle {
            id: dislikesRect

            anchors.left: likesRect.right
            anchors.right: parent.right
            height: parent.height

            color: likesCount == -1 || dislikesCount == -1 ? "darkgray" : "red"
        }
    }
}
