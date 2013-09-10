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
    id: aboutPage

    tools: ToolBarLayout {
        ToolIcon {
            iconId: "toolbar-back"
            onClicked: aboutPage.backRequested();
        }
    }

    signal backRequested

    HeaderRect {
        id: header
        title: "About"
    }

    Label {
        id: licenseLabel

        anchors.top: header.bottom
        anchors.left: parent.left

        font.pixelSize: 28

        text: "License: GPL v3"
    }

    Label {
        id: versionLabel

        anchors.top: licenseLabel.bottom
        anchors.left: parent.left

        font.pixelSize: 28

        text: "Version: 1.0.0"
    }

    Text {
        id: sourceCodeUrlLabel

        anchors.top: versionLabel.bottom
        anchors.left: parent.left

        font.pixelSize: 24

        textFormat: Text.RichText

        text: "<a href='https://github.com/mhmtipek/hey'>https://github.com/mhmtipek/hey</a>"

        onLinkActivated: Qt.openUrlExternally(link);
    }
}
