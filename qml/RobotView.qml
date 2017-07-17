import QtQuick 2.0

Rectangle {
    id: mainRect
    width: 480
    height: 712 - 40
    color: "#4C4C4C"

    signal command(string cmd)

    Item {
        anchors.centerIn: parent
        width: parent.width - 20
        height: width

        RobotViewGripper {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            rotation: 270
            gripperColor: "blue"

            onMoveIn: mainRect.command("move y in")
            onMoveOut: mainRect.command("move y out")
            onRotateClockwise: mainRect.command("rotate a clockwise")
            onRotateAntiClockwise: mainRect.command("rotate a anti clockwise")
        }

        RobotViewGripper {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            rotation: 90
            gripperColor: "green"

            onMoveIn: mainRect.command("move y in")
            onMoveOut: mainRect.command("move y out")
            onRotateClockwise: mainRect.command("rotate b clockwise")
            onRotateAntiClockwise: mainRect.command("rotate b anti clockwise")
        }

        RobotViewGripper {
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            rotation: 0
            gripperColor: "red"

            onMoveIn: mainRect.command("move x in")
            onMoveOut: mainRect.command("move x out")
            onRotateClockwise: mainRect.command("rotate c clockwise")
            onRotateAntiClockwise: mainRect.command("rotate c anti clockwise")
        }

        RobotViewGripper {
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            rotation: 180
            gripperColor: "orange"

            onMoveIn: mainRect.command("move x in")
            onMoveOut: mainRect.command("move x out")
            onRotateClockwise: mainRect.command("rotate d clockwise")
            onRotateAntiClockwise: mainRect.command("rotate d anti clockwise")
        }
    }
}
