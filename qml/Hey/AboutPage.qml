// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
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

        text: "Version: 0.0.1"
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
