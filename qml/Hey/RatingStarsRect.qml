// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0

Rectangle {
    color: "transparent"

    property int ratingMax: 4
    property real rating: -1.0

    onRatingMaxChanged: updateImages();
    onRatingChanged: updateImages();

    function updateImages() {
        star1.source = getImageSourceForIndex(1);
        star2.source = getImageSourceForIndex(2);
        star3.source = getImageSourceForIndex(3);
        star4.source = getImageSourceForIndex(4);
        star5.source = getImageSourceForIndex(5);
    }

    function getImageSourceForIndex(index) {
        if (rating < 0 || ratingMax == 0)
            return "";

        var value = rating / ratingMax;

        if (value >= index / 5.0)
            return "qrc:/star1.png";
        else if (value > (index - 1) / 5.0)
            return "qrc:/star2.png";
        else
            return "qrc:/star3.png";
    }

    Image {
        id: star1

        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: parent.width / 5

        source: getImageSourceForIndex(1)
    }

    Image {
        id: star2

        anchors.left: star1.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: parent.width / 5

        source: getImageSourceForIndex(2)
    }

    Image {
        id: star3

        anchors.left: star2.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: parent.width / 5

        source: getImageSourceForIndex(3)
    }

    Image {
        id: star4

        anchors.left: star3.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: parent.width / 5

        source: getImageSourceForIndex(4)
    }

    Image {
        id: star5

        anchors.left: star4.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: parent.width / 5

        source: getImageSourceForIndex(5)
    }
}
