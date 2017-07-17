import QtQuick 2.2
import QtGraphicalEffects 1.0


Rectangle {
    id: mainRect
    width: 125
    height: 180
    color: "#4C4C4C"

    property alias gripperColor: gripper.color

    signal moveIn()
    signal moveOut()
    signal rotateClockwise()
    signal rotateAntiClockwise()

    Rectangle {
        anchors.centerIn: parent
        id: gripper
        width: 25
        height: 80
        color: "red"
        Rectangle {
            width: 15
            height: 60
            y: 10
            color: mainRect.color
        }
    }

    Image {
        id: arrowOut
        anchors.verticalCenter: gripper.verticalCenter
        anchors.left: gripper.right
        anchors.leftMargin: 5

        width: 45; height: 45
        fillMode: Image.PreserveAspectFit
        smooth: true
        source: "images/arrow_right_black.png"

        opacity: arrowOutMouseArea.pressed ? 0.2 : 1
        Behavior on opacity { NumberAnimation { duration: 100 } }

        MouseArea {
            id: arrowOutMouseArea
            anchors.fill: parent
            onClicked: mainRect.moveOut()
        }
    }

    Image {
        id: arrowIn
        anchors.verticalCenter: gripper.verticalCenter
        anchors.right: gripper.left
        anchors.rightMargin: 5

        rotation: 180
        width: 45; height: 45
        fillMode: Image.PreserveAspectFit
        smooth: true
        source: "images/arrow_right_black.png"

        opacity: arrowInMouseArea.pressed ? 0.2 : 1
        Behavior on opacity { NumberAnimation { duration: 100 } }

        MouseArea {
            id: arrowInMouseArea
            anchors.fill: parent
            onClicked: mainRect.moveIn()
        }
    }

    Image {
        id: arrowAntiClockwise
        anchors.horizontalCenter: gripper.horizontalCenter
        anchors.bottom: gripper.top
        anchors.bottomMargin: 5

        rotation: 270
        width: 45; height: 45
        fillMode: Image.PreserveAspectFit
        smooth: true
        source: "images/arrow_right_black.png"

        opacity: arrowAntiClockwiseMouseArea.pressed ? 0.2 : 1
        Behavior on opacity { NumberAnimation { duration: 100 } }

        MouseArea {
            id: arrowAntiClockwiseMouseArea
            anchors.fill: parent
            onClicked: mainRect.rotateAntiClockwise()
        }
    }

    Image {
        id: arrowClockwise
        anchors.horizontalCenter: gripper.horizontalCenter
        anchors.top: gripper.bottom
        anchors.topMargin: 5

        rotation: 90
        width: 45; height: 45
        fillMode: Image.PreserveAspectFit
        smooth: true
        source: "images/arrow_right_black.png"

        opacity: arrowClockwiseMouseArea.pressed ? 0.2 : 1
        Behavior on opacity { NumberAnimation { duration: 100 } }


        MouseArea {
            id: arrowClockwiseMouseArea
            anchors.fill: parent
            onClicked: mainRect.rotateClockwise()
        }
    }
}
