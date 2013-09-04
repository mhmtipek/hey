import QtQuick 1.1
import com.nokia.meego 1.0

Page {
    id: searchResultPage

    tools: ToolBarLayout {
        ToolIcon {
            iconId: "toolbar-back"
            onClicked: searchResultPage.backRequested();
        }
    }

    property variant results: []
    property variant generalSpacing: 10

    signal backRequested
    signal showVideoDetailsRequested

    property variant currentVideoData: ({})

    onResultsChanged: {
        if (results.length == 0) {
            errorText.visible = true;
            resultListView.visible = false;
        } else {
            errorText.visible = false;
            resultListView.visible = true;
            header.title = "Search Results [1 - " + results.length + "]";
        }

        resultListView.model.clear();

        for (var i in results)
            resultListView.model.append(results[i]);
    }

    HeaderRect {
        id: header
        title: "Search Results"
    }

    Label {
        id: errorText

        anchors.top: header.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.topMargin: 100

        font.pixelSize: 60
        font.bold: false

        color: "#b5b5b5"

        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter

        text: "No results"
    }

    ListView {
        id: resultListView
        anchors.top: header.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.leftMargin: 10
        anchors.rightMargin: 10

        spacing: 10
        clip: true
        highlightFollowsCurrentItem: true
        highlightMoveSpeed: 10000

        delegate: Rectangle {
            width: parent.width
            height: titleText.height + authorText.height > thumbnail.height ? titleText.height + authorText.height
                                                                            : thumbnail.height
            color: "transparent"

            property variant videoData: {
                "id": id,
                "title": title,
                "author": author,
                "imageSource": imageSource,
                "duration": duration,
                "bigImageSource": bigImageSource,
                "url": url,
                "description": description,
                "viewCount": viewCount,
                "rating": rating,
                "likeCount": likeCount,
                "dislikeCount": dislikeCount,
                "ytUrl": ytUrl
            };

            Component.onCompleted: {
                videoDetailsDelegate.visible = true;
                loadMoreButton.visible = false;
//                videoDetailsDelegate.visible = (index != results.length - 1);
//                loadMoreButton.visible = (index == results.length - 1);
            }

            Item {
                anchors.fill: parent

                id: videoDetailsDelegate
                Image {
                    id: thumbnail
                    source: imageSource
                    width: 120
                    height: 90

                    Rectangle {
                        width: durationText.paintedWidth + 4
                        height: durationText.paintedHeight + 4
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                        radius: 3
                        anchors.bottomMargin: 4
                        anchors.rightMargin: 4
                        color: Qt.rgba(0, 0, 0, 0.6)
                        Label {
                            id: durationText
                            text: {
                                var seconds = "" + parseInt(duration % 60);
                                if (seconds.length == 1)
                                    seconds = "0" + seconds

                                return "" + parseInt(Math.floor(duration / 60.0)) + ":" + seconds
                            }

                            anchors.centerIn: parent
                            platformStyle: LabelStyle {
                                fontPixelSize: 16
                                textColor: "#F1F1F1"
                            }
                        }
                    }
                }
                Label {
                    id: titleText
                    x: thumbnail.width + 10
                    y: 0
                    text: title
                    font.pointSize: 22
                }
                Label {
                    id: authorText
                    anchors.top: titleText.bottom
                    x: titleText.x
                    text: author
                    font.pixelSize: 16
                    font.italic: true
                    color: "#464646"
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        searchResultPage.currentVideoData = videoData
                        resultListView.currentIndex = index;
                        searchResultPage.showVideoDetailsRequested();
                    }
                }
            }

            Button {
                id: loadMoreButton
                width: parent.width

                onClicked: {
                    console.log("Load Moar!!");
                }
            }
        }
        model: ListModel {
            id: listModel
        }
        highlight: Rectangle {
            color: "lightgray"
        }
    }
}
