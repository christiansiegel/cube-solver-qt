import QtQuick 2.0

Rectangle {
    id: mainRect
    width: 480
    height: {
        if(msgText.height > 60)
            return msgText.height + 20
        return 60
    }

    color: "#A0FF0000"
    state: "success"

    property bool showInfoIcon: false

    function setMessage (success, text) {
        if(text.length !== 0) {
            state = success ? "success" : "warning";
            msgText.text = text;
        }
        else
        {
            state = "invisible"
        }
    }

    Image {
        id: warningIcon
        anchors.left: parent.left
        anchors.leftMargin: 5
        anchors.verticalCenter: parent.verticalCenter

        width: 45; height: 45
        fillMode: Image.PreserveAspectFit
        smooth: true
        source: showInfoIcon ? "images/symbol_info.png" : "images/symbol_warning.png"
    }

    Image {
        id: successIcon
        anchors.left: parent.left
        anchors.leftMargin: 5
        anchors.verticalCenter: parent.verticalCenter

        width: 45; height: 45
        fillMode: Image.PreserveAspectFit
        smooth: true
        source: showInfoIcon ? "images/symbol_info.png" : "images/symbol_check.png"
    }

    Text {
        id: msgText
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: warningIcon.right
        anchors.leftMargin: 10
        anchors.right: parent.right
        anchors.rightMargin: 10

        font.pixelSize: 18
        font.family: "Droid Sans"

        wrapMode: Text.WordWrap

        text: "Es existiert nicht genau eine Seite jeder Farbe. "
    }

    states: [
        State {
            name: "warning"
            PropertyChanges { target: successIcon; opacity: 0 }
            PropertyChanges { target: warningIcon; opacity: 1 }
            PropertyChanges { target: mainRect; opacity: 1 }
            PropertyChanges { target: mainRect; color: "#A0FF0000" }
        },
        State {
            name: "success"
            PropertyChanges { target: successIcon; opacity: 1 }
            PropertyChanges { target: warningIcon; opacity: 0 }
            PropertyChanges { target: mainRect; opacity: 1 }
            PropertyChanges { target: mainRect; color: "#A080FF00" }
        },
        State {
            name: "invisible"
            PropertyChanges { target: mainRect; opacity: 0 }
            PropertyChanges { target: mainRect; color: "#FF000000" }
        }
    ]

    transitions: [
        Transition {
            NumberAnimation { target: mainRect; property: "opacity"; duration: 200}
            ColorAnimation { target: mainRect; duration: 200 }
        }
    ]
}
