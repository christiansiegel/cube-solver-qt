import QtQuick 2.2
import QtQuick.Controls 1.1

ApplicationWindow {
    visible: true
    width: 480
    height: 800 - 40
    title: qsTr("CubeSolver")

    color: "#4C4C4C"

    Rectangle {
        id: colorBarTop
        width: parent.width
        height: 10
        anchors.top: parent.top
        color: viewIndicatorVision.color
    }

    ListView {
        id: viewsPane
        width: parent.width
        anchors.top: colorBarTop.bottom
        anchors.bottom: colorBarBottom.top

        model: viewsModel

        orientation: ListView.Horizontal
        snapMode: ListView.SnapOneItem
        boundsBehavior: Flickable.StopAtBounds

        onContentXChanged: {
            var index = Math.round(contentX / parent.width)
            switch(index) {
            case 0: state = "visionView"; break;
            case 1: state = "processView"; break;
            case 2: state = "statisticsView"; break;
            case 3: state = "consoleView"; break;
            case 4: state = "robotView"; break;
            }
        }

        states: [
            State {
                name: "visionView"
                PropertyChanges { target: viewIndicatorVision; y: 0 }
                PropertyChanges { target: viewIndicatorProcess; y: 10 }
                PropertyChanges { target: viewIndicatorStatistics; y: 10 }
                PropertyChanges { target: viewIndicatorConsole; y: 10 }
                PropertyChanges { target: viewIndicatorRobot; y: 10 }
                PropertyChanges { target: colorBarTop; color: viewIndicatorVision.color }
                PropertyChanges { target: commandIconBar; opacity: 1 }
            },
            State {
                name: "processView"
                PropertyChanges { target: viewIndicatorVision; y: 10 }
                PropertyChanges { target: viewIndicatorProcess; y: 0 }
                PropertyChanges { target: viewIndicatorStatistics; y: 10 }
                PropertyChanges { target: viewIndicatorConsole; y: 10 }
                PropertyChanges { target: viewIndicatorRobot; y: 10 }
                PropertyChanges { target: colorBarTop; color: viewIndicatorProcess.color }
                PropertyChanges { target: commandIconBar; opacity: 1 }
            },
            State {
                name: "statisticsView"
                PropertyChanges { target: viewIndicatorVision; y: 10 }
                PropertyChanges { target: viewIndicatorProcess; y: 10 }
                PropertyChanges { target: viewIndicatorStatistics; y: 0 }
                PropertyChanges { target: viewIndicatorConsole; y: 10 }
                PropertyChanges { target: viewIndicatorRobot; y: 10 }
                PropertyChanges { target: colorBarTop; color: viewIndicatorStatistics.color }
                PropertyChanges { target: commandIconBar; opacity: 0 }
            },
            State {
                name: "consoleView"
                PropertyChanges { target: viewIndicatorVision; y: 10 }
                PropertyChanges { target: viewIndicatorProcess; y: 10 }
                PropertyChanges { target: viewIndicatorStatistics; y: 10 }
                PropertyChanges { target: viewIndicatorConsole; y: 0 }
                PropertyChanges { target: viewIndicatorRobot; y: 10 }
                PropertyChanges { target: colorBarTop; color: viewIndicatorConsole.color }
                PropertyChanges { target: commandIconBar; opacity: 0 }
            },
            State {
                name: "robotView"
                PropertyChanges { target: viewIndicatorVision; y: 10 }
                PropertyChanges { target: viewIndicatorProcess; y: 10 }
                PropertyChanges { target: viewIndicatorStatistics; y: 10 }
                PropertyChanges { target: viewIndicatorConsole; y: 10 }
                PropertyChanges { target: viewIndicatorRobot; y: 0 }
                PropertyChanges { target: colorBarTop; color: viewIndicatorRobot.color }
                PropertyChanges { target: commandIconBar; opacity: 0 }
            }
        ]

        transitions: [
            Transition {
                ColorAnimation { target: colorBarTop; duration: 200}
                NumberAnimation { property: "y"; duration: 200}
                NumberAnimation { target: commandIconBar; property: "opacity"; duration: 200}
            }
        ]

        function setView(index) {
            changeViewAnimation.toX = width * index
            changeViewAnimation.start()
        }

        SequentialAnimation {
            id: changeViewAnimation
            property alias toX: contentXAnimation.to
            NumberAnimation { target: viewsPane; properties: "opacity"; to: 0; duration: 200;}
            NumberAnimation { id: contentXAnimation; target: viewsPane; properties: "contentX"; to: 0; duration: 0;}
            NumberAnimation { target: viewsPane; properties: "opacity"; to: 1; duration: 200;}
        }
    }

    VisualItemModel {
        id: viewsModel

        VisionView {
            id: visionView
            width: viewsPane.width; height: viewsPane.height;
            onCubeScanned: {
                processView.setCubeScanned("finished")
                consoleView.addLog("cube scan finished")
            }
            onCubeSolved: {
                processView.setSolutionComputed("finished", solution, msecs)
                consoleView.addLog("cube solution computed (" + msecs + "ms):\n" + solution)
            }
        }// Rectangle { width: viewsPane.width; height: viewsPane.height; color: "black" }

        ProcessView {
            id: processView;
            width: viewsPane.width; height: viewsPane.height;
        }

        Rectangle { width: viewsPane.width; height: viewsPane.height; color: "black" }

        ConsoleView {
            id: consoleView
            width: viewsPane.width; height: viewsPane.height;
        }

        RobotView {
            id: robotView
            width: viewsPane.width; height: viewsPane.height;
            onCommand: {
                consoleView.addLog("sent manual command to robot:\n" + cmd)
            }

        }

    }

    Rectangle {
        id: colorBarBottom
        width: parent.width
        height: 10
        anchors.bottom: viewIndicatorBar.top
        color: colorBarTop.color
    }

    Item {
        id: viewIndicatorBar
        width: parent.width
        height: 48 + 10 + 10
        anchors.bottom: parent.bottom
        anchors.left: parent.left

        IconButton {
            id: viewIndicatorVision
            y: 0
            anchors.left: parent.left
            anchors.leftMargin: 10
            color: "#0000DD"
            imageSource: "images/symbol_eye.png"

            MouseArea {
                anchors.fill: parent
                onClicked: viewsPane.setView(0)
            }
        }

        IconButton {
            id: viewIndicatorProcess
            y: 10
            anchors.left: viewIndicatorVision.right
            anchors.leftMargin: 10
            color: "#00DD6E"
            imageSource: "images/symbol_process.png"

            MouseArea {
                anchors.fill: parent
                onClicked: viewsPane.setView(1)
            }
        }

        IconButton {
            id: viewIndicatorStatistics
            y: 10
            anchors.left: viewIndicatorProcess.right
            anchors.leftMargin: 10
            color: "#DD006E"
            imageSource: "images/symbol_statistics.png"

            MouseArea {
                anchors.fill: parent
                onClicked: viewsPane.setView(2)
            }
        }

        IconButton {
            id: viewIndicatorConsole
            y: 10
            anchors.left: viewIndicatorStatistics.right
            anchors.leftMargin: 10
            color: "#DDDD00"
            imageSource: "images/symbol_console.png"

            MouseArea {
                anchors.fill: parent
                onClicked: viewsPane.setView(3)
            }
        }

        IconButton {
            id: viewIndicatorRobot
            y: 10
            anchors.left: viewIndicatorConsole.right
            anchors.leftMargin: 10
            color: "orange"
            imageSource: "images/symbol_robot.png"

            MouseArea {
                anchors.fill: parent
                onClicked: viewsPane.setView(4)
            }
        }
    }

    Item {
        id: commandIconBar
        width: parent.width
        height: viewIndicatorBar.height
        anchors.bottom: parent.bottom
        anchors.right: parent.right

        state: "play"

        IconButton {
            id: playCommandIcon
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            color: "#333333"
            imageSource: "images/symbol_play.png"
        }

        IconButton {
            id: stopCommandIcon
            anchors.centerIn: playCommandIcon
            color: "#333333"
            imageSource: "images/symbol_hand.png"
        }

        MouseArea {
            anchors.fill: stopCommandIcon
            onClicked: {
                if(commandIconBar.state === "play") {


                    //play not implemented yet -> resume process

                     commandIconBar.state = "stop"
                }
                else {

                    //stop not implemented yet -> send abort to robot
                    commandIconBar.state = "play"
                }

            }
        }

        IconButton {
            id: resetCommandIcon
            anchors.right: playCommandIcon.left
            anchors.rightMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            color: "#333333"
            imageSource: "images/symbol_reset.png"

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    parent.rotateIcon180()
                    visionView.resetAll()
                    processView.resetAll()
                }
            }
        }

        states: [
            State {
                name: "play"
                PropertyChanges { target: playCommandIcon; opacity: 1 }
                PropertyChanges { target: stopCommandIcon; opacity: 0 }
            },
            State {
                name: "stop"
                PropertyChanges { target: playCommandIcon; opacity: 0 }
                PropertyChanges { target: stopCommandIcon; opacity: 1 }
            }
        ]

        transitions: [
            Transition {
                NumberAnimation { targets: [startCommandIcon, stopCommandIcon]; property: "opacity"; duration: 200}
            }
        ]
    }
}

