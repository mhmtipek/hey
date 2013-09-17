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

Page {
    id: searchPage

    tools: ToolBarLayout {
        id: commonTools
        visible: true

        ToolIcon {
            id: backToSearchResultsButton
            visible: false
            iconId: "toolbar-list"
            anchors.left: (parent === undefined) ? undefined : parent.left
            onClicked: navigateToResultPageRequested();

            onEnabledChanged: {
                iconId = enabled ? "toolbar-list" : "toolbar-list-dimmed";
            }
        }

        ToolIcon {
            platformIconId: "toolbar-view-menu"
            anchors.right: (parent === undefined) ? undefined : parent.right
            onClicked: (myMenu.status === DialogStatus.Closed) ? myMenu.open() : myMenu.close()
        }
    }

    property variant searchResults: []
    property string errorstring: ""
    property int state: 0
    property int defaultMargin: 10

    signal started
    signal finished
    signal error
    signal progress(int p) /* Range: 0-4 */
    signal navigateToResultPageRequested

    onStarted: {
        statusText.text = "Searching ...";
    }

    onFinished: {
        statusText.text = "Finished.";
        backToSearchResultsButton.enabled = true;
    }

    onError: {
        statusText.text = "Error: " + errorstring;
    }

    function clear() {
        statusText.text = "Enter search input";
    }

    function showBackToSearchResultPageButton() {
        backToSearchResultsButton.visible = true;
    }

    HeaderRect {
        id: header
        title: "Search Videos"
    }

    TextField {
        id: searchTextField

        text: ""
        placeholderText: "Search"

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: header.bottom
        anchors.margins: defaultMargin

        signal accepted
        signal statusChanged(int state)

        validator: RegExpValidator {
            regExp: /.+/i
        }

        Image {
            id: searchImage

            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom

            source: "image://theme/icon-m-common-search";

            smooth: true

            MouseArea {
                anchors.fill: parent
                onClicked: searchTextField.accepted();
            }
        }

        onAccepted: {
            if (searchTextField.text.length == 0)
                return;

            backToSearchResultsButton.enabled = false;

            var doc = new XMLHttpRequest();
            doc.onreadystatechange = function() {
                progress(doc.readyState)
                if (doc.readyState == XMLHttpRequest.DONE) {
                    if (doc.status == 200) {
                        var resultList = [];
                        var result = JSON.parse(doc.responseText);
                        for (var index in result.feed.entry) {
                            resultList.push(createVideoData(result.feed.entry[index]));
                        }

                        searchPage.searchResults = resultList;
                        finished();
                    } else {
                        if (doc.status == 0)
                            errorstring = "No internet connection";
                        else
                            errorstring = "Http code: " + doc.status;

                        error();
                    }
                }
                console.log("Ready State: " + doc.readyState);
            }

            started();
            statusText.focus = true;

            var url = "http://gdata.youtube.com/feeds/api/videos?q=" + searchTextField.text + "&alt=json&v=2&max-results=50";
            doc.open("GET", url);
            doc.send();
        }
    }

    Label {
        id: statusText

        anchors.top: searchTextField.bottom
        anchors.topMargin: 100
        anchors.left: parent.left
        anchors.right: parent.right

        font.pixelSize: 60
        font.bold: false

        color: "#b5b5b5"

        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter

        text: "Enter search input"
    }

    function createVideoData(ytData) {
        //TODO: Look for video properties if exist

        var id = ytData.yt$videoid;
        var title = ytData.title.$t;
        var author = ytData.author[0].name.$t;
        var imageSource = ytData.media$group.media$thumbnail[0].url;
        var duration = ytData.media$group.yt$duration.seconds;

        var bigImageSource = ytData.media$group.media$thumbnail[2].url;

        var url = "";
        for (var mediaContentIndex in ytData.media$group.media$content) {
            if (ytData.media$group.media$content[mediaContentIndex].type == "video/3gpp") {
                url = ytData.media$group.media$content[mediaContentIndex].url;
                break;
            }
        }

        var ytUrl = "";
        for (var linkIndex in ytData.link) {
            if (ytData.link[linkIndex].type == "text/html") {
                ytUrl = ytData.link[linkIndex].href;
            }
        }

        var viewCount = -1;
        if (ytData.hasOwnProperty("yt$statistics"))
            viewCount = ytData.yt$statistics.viewCount;

        var description = ytData.media$group.media$description.$t;

        var rating = -1.0;
        if (ytData.hasOwnProperty("gd$rating"))
            rating = ytData.gd$rating.average;

        var likeCount = -1;
        var dislikeCount = -1;

        if (ytData.hasOwnProperty("yt$rating")) {
            likeCount = ytData.yt$rating.numLikes;
            dislikeCount = ytData.yt$rating.numDislikes;
        }

        return {
            "id": id,
            "title": title,
            "author": author,
            "imageSource": imageSource,
            "duration": duration,
            "bigImageSource": bigImageSource,
            "url": url,
            "viewCount": viewCount,
            "description": description,
            "rating": rating,
            "likeCount": likeCount,
            "dislikeCount": dislikeCount,
            "ytUrl": ytUrl
        };
    }
}
