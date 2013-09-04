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
