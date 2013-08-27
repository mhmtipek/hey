// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0
import org.mhmtipek.hey 1.0

Page {
    id: videoDetailsPage

    property variant videoData: ({})

    signal backRequested

    tools: ToolBarLayout {
        ToolIcon {
            iconId: "toolbar-back"
            onClicked: videoDetailsPage.backRequested();
        }
    }

    onVideoDataChanged: {
        clearAll();

        thumbnail.imageSource = videoData.bigImageSource;
        thumbnail.durationText = createDurationText(videoData.duration);

        titleLabel.text = videoData.title;
        authorLabel.text = videoData.author;
        viewCountLabel.text = videoData.viewCount == -1 ? "No view count information"
                                                        : "Viewed " + videoData.viewCount + " times";

        descriptionLabel.text = videoData.description;

        ratingRect.likesCount = videoData.likeCount;
        ratingRect.dislikesCount = videoData.dislikeCount;
    }

    function clearAll() {
        thumbnail.clear();
        clickToPlayImage.visible = false;
        titleLabel.text = "";
        authorLabel.text = "";
        viewCountLabel.text = "";
        descriptionLabel.text = "";
    }

    function createDurationText(duration) {
        var seconds = "" + parseInt(videoData.duration % 60);
        if (seconds.length == 1)
            seconds = "0" + seconds;

        return "" + parseInt(Math.floor(videoData.duration / 60.0))
                  + ":" + seconds;
    }

    HeaderRect {
        id: header
        title: "Video Details"
    }

    Flickable {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: header.bottom
        anchors.bottom: parent.bottom

        contentWidth: width
        contentHeight: thumbnail.height + detailsViewArea.height

        clip: true

        ThumbnailImage {
            id: thumbnail

            height: (width / 4.0) * 3.0

            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 10

            durationTextFontPixelSize: 26

            onLoaded: clickToPlayImage.visible = true

            Image {
                id: clickToPlayImage
                visible: false

                anchors.centerIn: parent
                source: "image://theme/icon-l-common-video-playback"

                opacity: 0.48
            }

            SequentialAnimation {
                id: openingVideoAnimation

                running: false
                loops: Animation.Infinite

                NumberAnimation {
                    target: clickToPlayImage;
                    property: "opacity";
                    duration: 600;
                    easing.type: Easing.InOutQuad
                    from: 0.48
                    to: 0
                }

                NumberAnimation {
                    target: clickToPlayImage;
                    property: "opacity";
                    duration: 600;
                    easing.type: Easing.InOutQuad
                    from: 0
                    to: 0.48
                }
            }


            MouseArea {
                anchors.fill: parent
                onClicked: {
                    openingVideoAnimation.start();

                    if (!Qt.openUrlExternally(videoData.url))
                        Console.log("openexternally failed");
                }
            }
        }

        Item {
            id: detailsViewArea

            anchors.top: thumbnail.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.leftMargin: 10
            anchors.rightMargin: 10

            Label {
                id: titleLabel

                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right

                font.pixelSize: 26
            }

            Label {
                id: authorLabel

                anchors.top: titleLabel.bottom
                anchors.left: parent.left
                anchors.right: parent.right

                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignLeft

                font.pixelSize: 20
                font.italic: true

                color: "#7C7C7C"
            }

            Label {
                id: viewCountLabel

                anchors.top: authorLabel.bottom
                anchors.left: parent.left
                anchors.right: parent.right

                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignLeft

                font.pixelSize: 22
                color: "#363636"
            }

            RatingRect {
                id: ratingRect

                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: viewCountLabel.bottom
            }

            Label {
                id: descriptionLabel

                anchors.top: ratingRect.bottom
                anchors.topMargin: 10
                anchors.left: parent.left
                anchors.right: parent.right

                verticalAlignment: Text.AlignTop
                horizontalAlignment: Text.AlignLeft

                font.pixelSize: 20
                color: "#6A6A6A"
            }
        }
    }

    WindowActions {
        onFocusChanged: {
            if (!hasFocus) {
                openingVideoAnimation.stop();
                clickToPlayImage.opacity = 0.48;
            }
        }
    }
}
