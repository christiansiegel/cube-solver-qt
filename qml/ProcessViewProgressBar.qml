import QtQuick 2.0

Rectangle {
    id: mainRect
    width: 480
    height: {
        if(msgText.height > 60)
            return msgText.height + 20
        return 60
    }

    state: "waiting"
    property alias text: msgText.text


    ProcessViewRunningIcon {
        id: icon
        anchors.right: parent.right
        anchors.rightMargin: 5
        anchors.verticalCenter: parent.verticalCenter

        width: 45; height: 45
        state: "running"
    }


    Text {
        id: msgText
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.right: icon.left
        anchors.rightMargin: 10

        font.pixelSize: 18
        font.family: "Droid Sans"

        wrapMode: Text.WordWrap

        text: "Es existiert nicht genau eine Seite jeder Farbe. "
    }

    states: [
        State {
            name: "running"
            PropertyChanges { target: mainRect; color: "orange" }
            PropertyChanges { target: icon; state: "running" }
        },
        State {
            name: "finished"
            PropertyChanges { target: mainRect; color: "#A080FF00" }
            PropertyChanges { target: icon; state: "finished" }
        },
        State {
            name: "waiting"
            PropertyChanges { target: mainRect; color: "#333333" }
            PropertyChanges { target: icon; state: "invisible" }
        }
    ]

    transitions: [
        Transition {
            ColorAnimation { target: mainRect; duration: 200 }
        }
    ]
}
