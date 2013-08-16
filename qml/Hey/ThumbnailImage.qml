// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0

Rectangle {
    id: thumbnailImage

    property string imageSource: ""
    property string durationText: ""
    property real durationTextFontPixelSize: 16

    signal loaded

    Image {
        id: image
        anchors.fill: parent

        source: imageSource

        onProgressChanged: {
            if (progress == 1.0) {
                thumbnailLoadingProgressLabel.visible = false;
                durationRect.visible = true;
                loaded();
            } else {
                thumbnailLoadingProgressLabel.text = "Loading... %" + Math.round(progress * 100);
            }
        }

        Label {
            id: thumbnailLoadingProgressLabel
            anchors.fill: parent

            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter

            text: "Loading...";
        }

        Rectangle {
            id: durationRect

            width: durationLabel.paintedWidth + 4
            height: durationLabel.paintedHeight + 4
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            radius: 3
            anchors.bottomMargin: 4
            anchors.rightMargin: 4
            color: Qt.rgba(0, 0, 0, 0.6)
            Label {
                id: durationLabel
                text: durationText

                anchors.centerIn: parent
                platformStyle: LabelStyle {
                    fontPixelSize: durationTextFontPixelSize
                    textColor: "#F1F1F1"
                }
            }
        }
    }

    function clear() {
        imageSource = "";
        durationText = "";
        thumbnailLoadingProgressLabel.text = "Loading...";
        thumbnailLoadingProgressLabel.visible = true;
        durationRect.visible = false;
    }
}
