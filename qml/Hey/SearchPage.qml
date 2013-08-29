// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0

Page {
    id: searchPage

    tools: commonTools

    property variant searchResults: []
    property string errorstring: ""
    property int state: 0
    property int defaultMargin: 10

    signal started
    signal finished
    signal error
    signal progress(int p) /* Range: 0-4 */

    onStarted: {
        statusText.text = "Searching ...";
    }

    onFinished: {
        statusText.text = "Finished.";
    }

    onError: {
        statusText.text = "Error: " + errorstring;
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

        onAccepted: {
            if (searchTextField.text.length == 0)
                return;

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
                        errorString = "Error. Http code: " + doc.status;
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
            "dislikeCount": dislikeCount
        };
    }
}
