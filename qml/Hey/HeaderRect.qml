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
    id: header

    height: 70

    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right

    color: "red"

    property string title: ""

    Label {
        y: (parent.height - height) / 2

        anchors.left: parent.left
        anchors.leftMargin: 25
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft

        text: title
        font.pixelSize: 32
        font.bold: false
        color: "white"
    }
}
