import QtQuick 2.0

Item {
    width: 100
    height: 100

    state: "invisible"

    Image {
        id: runningImage
        anchors.centerIn: parent

        width: parent.width
        height: parent.height
        fillMode: Image.PreserveAspectFit
        smooth: true
        source: "images/symbol_rotate.png"

    }

    Image {
        id: finishedImage
        anchors.centerIn: parent

        width: parent.width
        height: parent.height
        fillMode: Image.PreserveAspectFit
        smooth: true

        source: "images/symbol_check.png"


    }


    RotationAnimation {
        id: rotateAnimation
        target: runningImage
        direction: RotationAnimation.Clockwise
        from: 0
        to: 360
        loops: Animation.Infinite;
        duration: 1000
    }

    Component.onCompleted: rotateAnimation.start()


    states: [
        State {
            name: "running"
            PropertyChanges { target: runningImage; opacity: 1 }
            PropertyChanges { target: finishedImage; opacity: 0 }
        },
        State {
            name: "finished"
            PropertyChanges { target: runningImage; opacity: 0 }
            PropertyChanges { target: finishedImage; opacity: 1 }
        },
        State {
            name: "invisible"
            PropertyChanges { target: runningImage; opacity: 0 }
            PropertyChanges { target: finishedImage; opacity: 0 }
        }
    ]

    onStateChanged: {
        if(state === "running")
            rotateAnimation.start()
        else
            rotateAnimation.stop()
    }

    transitions: [
        Transition {
            NumberAnimation { target: runningImage; property: "opacity"; duration: 200}
            NumberAnimation { target: finishedImage; property: "opacity"; duration: 200}
        }
    ]
}
