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

PageStackWindow {
    id: appWindow

    initialPage: searchPage

    SearchPage {
        id: searchPage

        onNavigateToResultPageRequested: {
            pageStack.replace(searchResultPage)
        }

        onFinished: {
            searchResultPage.results = searchResults;
            searchPage.showBackToSearchResultPageButton();
            pageStack.replace(searchResultPage);
        }
    }

    SearchResultPage {
        id: searchResultPage

        onBackRequested: {
            searchPage.clear();
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

    AboutPage {
        id: aboutPage

        onBackRequested: {
            pageStack.replace(searchPage);
        }
    }

    Menu {
        id: myMenu
        visualParent: pageStack
        MenuLayout {
            MenuItem {
                text: qsTr("About")

                onClicked: {
                    pageStack.replace(aboutPage);
                }
            }
        }
    }
}
