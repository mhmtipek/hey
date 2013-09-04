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
    id: ratingRect

    height: likesCountLabel.height + graph.height

    property int likesCount: 0
    property int dislikesCount: 0

    color: "transparent"

    function fixText(val) {
        if (val == -1)
            return "-";
        else
            return "" + val;
    }

    Label {
        id: likesCountLabel

        anchors.left: parent.left
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter

        text: fixText(likesCount);
        font.pixelSize: 22
        color: likesCount == -1 ? "darkgray" : "green"
    }

    Label {
        id: dislikesCountLabel

        anchors.right: parent.right
        horizontalAlignment: Text.AlignRight
        verticalAlignment: Text.AlignVCenter

        text: fixText(dislikesCount);
        font.pixelSize: 22
        color: dislikesCount == -1 ? "darkgray" : "red"
    }

    Rectangle {
        id: graph

        anchors.top: likesCountLabel.bottom
        width: parent.width
        height: 5

        Rectangle {
            id: likesRect

            width: parent.width * (likesCount / (likesCount + dislikesCount));

            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom

            color: likesCount == -1 || dislikesCount == -1 ? "darkgray" : "green"
        }

        Rectangle {
            id: dislikesRect

            anchors.left: likesRect.right
            anchors.right: parent.right
            height: parent.height

            color: likesCount == -1 || dislikesCount == -1 ? "darkgray" : "red"
        }
    }
}
