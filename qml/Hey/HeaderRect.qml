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

    function showNotification(text, duration, imageSource) {
        notificationLabel.text = text;
        notificationTimer.interval = duration;
        showNotificationAnimation.startNotificationTimerOnFinish = duration > 0;
        notificationImage.source = imageSource;
        notificationImage.visible = imageSource.length > 0;

        showNotificationAnimation.start();
    }

    function hideNotification() {
        hideNotificationAnimation.start();
    }

    Timer {
        id: notificationTimer
        repeat: false
        onTriggered: {
            hideNotification();
        }
    }

    Rectangle {
        width: parent.width
        height: parent.height - 20
        anchors.centerIn: parent

        color: parent.color

        clip: true

        Label {
            id: titleLabel

            x: 25
            y: 0
            width: parent.width
            height: parent.height
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft

            text: title
            font.pixelSize: 32
            font.bold: false
            color: "white"
        }

        Rectangle {
            x: 25
            width: titleLabel.width
            height: titleLabel.height
            anchors.top: titleLabel.bottom

            color: parent.color

            Image {
                id: notificationImage

                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: sourceSize.width * (height / sourceSize.height)

                source: "";
                smooth: true
            }

            Label {
                id: notificationLabel

                anchors.left: notificationImage.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom

                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignLeft

                font.pixelSize: 30
                font.bold: false
                font.italic: true
                color: "white"
            }
        }


        PropertyAnimation {
            id: showNotificationAnimation

            target: titleLabel
            property: "y"
            easing.type: Easing.InOutQuad
            duration: 200

            to: -1 * titleLabel.height

            property bool startNotificationTimerOnFinish: true

            onCompleted: {
                if (startNotificationTimerOnFinish)
                    notificationTimer.start();
            }
        }

        PropertyAnimation {
            id: hideNotificationAnimation

            target: titleLabel
            property: "y"
            easing.type: Easing.InOutQuad
            duration: 200

            to: 0
        }
    }
}
