import QtQuick 1.1
import com.nokia.meego 1.0

PageStackWindow {
    id: appWindow

    initialPage: searchPage

    SearchPage {
        id: searchPage

        onFinished: {
            searchResultPage.results = searchResults;
            pageStack.replace(searchResultPage);
        }
    }

    SearchResultPage {
        id: searchResultPage

        onBackRequested: {
            pageStack.replace(searchPage);
        }

        onShowVideoDetailsRequested: {
            videoDetailsPage.videoData = currentVideoData;
            pageStack.replace(videoDetailsPage);
        }
    }

    VideoDetailsPage {
        id: videoDetailsPage

        onBackRequested: {
            pageStack.replace(searchResultPage);
        }
    }

    ToolBarLayout {
        id: commonTools
        visible: true
        ToolIcon {
            platformIconId: "toolbar-view-menu"
            anchors.right: (parent === undefined) ? undefined : parent.right
            onClicked: (myMenu.status === DialogStatus.Closed) ? myMenu.open() : myMenu.close()
        }
    }

    Menu {
        id: myMenu
        visualParent: pageStack
        MenuLayout {
            MenuItem {
                text: qsTr("About")
            }
            MenuItem {
                text: qsTr("Quit")
                onClicked: Qt.quit();
            }
        }
    }
}
