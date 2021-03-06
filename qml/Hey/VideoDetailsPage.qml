/*
Copyright (C) 2013  Mehmet IPEK

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>
*/

import QtQuick 1.1
import com.nokia.meego 1.0
import org.mhmtipek.hey 1.0

Page {
    id: videoDetailsPage

    property variant videoData: ({})

    signal backRequested

    TextInput {
        id: clipboardCopyHelperTextInput
        visible: false
        text: ""

        function copyToSystemClipboard(textToCopy) {
            text = textToCopy;
            selectAll();
            copy();
        }
    }

    Menu {
        id: optionsMenu
        visualParent: pageStack
        MenuLayout {
            MenuItem {
                id: actionOpenInBrowser
                text: qsTr("Open In Browser")

                onClicked: {
                    Qt.openUrlExternally(videoData.ytUrl);
                    header.showNotification("Opening in browser ...", 0, "image://theme/icon-m-toolbar-refresh-selected");
                }
            }

            MenuItem {
                id: actionCopyLink
                text: qsTr("Copy Link");

                onClicked: {
                    clipboardCopyHelperTextInput.copyToSystemClipboard(videoData.ytUrl);
                    header.showNotification("Link copied", 1000, "image://theme/icon-m-toolbar-done-white-selected");
                }
            }
        }
    }

    tools: ToolBarLayout {
        ToolIcon {
            iconId: "toolbar-back"
            onClicked: {
                optionsMenu.close();
                videoDetailsPage.backRequested();
            }
        }

        ToolIcon {
            platformIconId: "toolbar-view-menu"
            onClicked: (optionsMenu.status === DialogStatus.Closed) ? optionsMenu.open() : optionsMenu.close();
        }
    }

    orientationLock: PageOrientation.LockPortrait

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

        actionOpenInBrowser.enabled = videoData.ytUrl != "";
        actionCopyLink.enabled = videoData.ytUrl != "";
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

    ThumbnailImage {
        id: thumbnail

        width: parent.width
        height: (width / 4.0) * 3.0

        anchors.top: header.bottom
        anchors.left: parent.left

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

    Flickable {
        id: videoDetailsFlickable

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: thumbnail.bottom
        anchors.bottom: parent.bottom

        contentWidth: allContent.width
        contentHeight: allContent.height

        clip: true

        Item {
            id: allContent
            width: videoDetailsFlickable.width
            height: detailsViewArea.height

            Item {
                id: detailsViewArea

                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 10
                anchors.rightMargin: 10

                height: titleLabel.height
                        + authorLabel.paintedHeight
                        + viewCountLabel.paintedHeight
                        + ratingRect.height
                        + descriptionLabel.paintedHeight

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
    }

    WindowActions {
        onFocusChanged: {
            if (!hasFocus) {
                openingVideoAnimation.stop();
                clickToPlayImage.opacity = 0.48;
                header.hideNotification();
            }
        }
    }
}
