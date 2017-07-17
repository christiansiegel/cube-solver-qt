import QtQuick 2.2
import QtMultimedia 5.0
import QtGraphicalEffects 1.0

import CubeSolverApp 1.0


Rectangle {
    id: mainRect
    width: 480
    height: 712 - 40
    color: "#4C4C4C"

    signal cubeScanned();
    signal cubeSolved(string solution, int msecs)

    function resetAll() {
        cube.resetAllColors()
        cubePane.state = "shadowInvisible"
        messageBar1.setMessage(false, "")
        messageBar2.setMessage(false, "")
    }

    Rectangle {
        id: imageProcessingBar
        width: parent.width
        height: 120 + 10 + 10
        anchors.top: parent.top
        anchors.topMargin: 30
        clip: true

        color: "#333333"

        VideoOutput {
            id: liveImage
            width: 120
            height: 160

            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 10

            source: camera
            orientation: 270

            Camera {
                id: camera

                imageProcessing {
                    whiteBalanceMode: CameraImageProcessing.WhiteBalanceTungsten
                    denoisingLevel: -1
                }
            }

            Rectangle {
                width: parent.width
                height: 20
                anchors.top: parent.top
                color: parent.parent.color
            }

            Rectangle {
                width: parent.width
                height: 20
                anchors.bottom: parent.bottom
                color: parent.parent.color
            }

            Component.onCompleted: ImageProcessor.setCameraObject(camera)
        }

        Image {
            id: arrowButton
            anchors.centerIn: parent
            height: parent.height; width: height
            fillMode: Image.PreserveAspectFit
            smooth: true
            source: "images/arrow_right_shadow.png"

            Image {
                id: arrowButtonGears
                anchors.centerIn: parent
                width: 60; height: 60
                fillMode: Image.PreserveAspectFit
                smooth: true
                source: "images/symbol_gear.png"
            }

            Glow {
                id: arrowButtonGearsGlow
                anchors.fill: arrowButtonGears
                radius: 20
                samples: 16
                color: "white"
                source: arrowButtonGears
                opacity: ImageProcessor.processingImage ? 1 : 0

            }

            MouseArea {
                anchors.fill: parent
                onClicked: ImageProcessor.captureImage("")
            }
        }

        Rectangle {
            anchors.fill: processedImage
            color: "black"
        }

        QImageItem {
        //Rectangle {
            id: processedImage
            width: 120
            height: 120

            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 10
            image: ImageProcessor.processedImage
        }
    }

    Item {
        id: cubePane

        width: parent.width
        height: 340
        anchors.top: imageProcessingBar.bottom

        state: "shadowInvisible"

        Image {
            id: cubeShadowRed
            anchors.centerIn: parent
            opacity: 0
            source: "images/cube_red_shadow.png"
        }

        Image {
            id: cubeShadowGreen
            anchors.centerIn: parent
            opacity: 0
            source: "images/cube_green_shadow.png"
        }

        Cube {
            id: cube
            anchors.centerIn: parent
            faceletSize: 30
        }

        states: [
            State {
                name: "shadowWarning"
                PropertyChanges { target: cubeShadowRed; opacity: 1 }
                PropertyChanges { target: cubeShadowGreen; opacity: 0 }
            },
            State {
                name: "shadowSuccess"
                PropertyChanges { target: cubeShadowRed; opacity: 0 }
                PropertyChanges { target: cubeShadowGreen; opacity: 1 }
            },
            State {
                name: "shadowInvisible"
                PropertyChanges { target: cubeShadowRed; opacity: 0 }
                PropertyChanges { target: cubeShadowGreen; opacity: 0 }
            }
        ]

        transitions: [
            Transition {
                NumberAnimation { target: cubeShadowRed; property: "opacity"; duration: 200}
                NumberAnimation { target: cubeShadowGreen; property: "opacity"; duration: 200}
            }
        ]
    }

    Item {
        id: messagePane
        width: parent.width
        anchors.top: cubePane.bottom
        anchors.bottom: parent.bottom

        VisionViewMessageBar {
            id: messageBar1
            width: parent.width
            anchors.top: parent.top

            state: "invisible"
        }

        VisionViewMessageBar {
            id: messageBar2
            width: parent.width
            anchors.top: messageBar1.bottom
            anchors.topMargin: 10

            state: "invisible"
            showInfoIcon: true
        }
    }

    Connections {
        target: ImageProcessor
        onProcessedImage: {
            if(side.length === 1) {
                cube.setSide(side, facelets)

                var faceletString = cube.getFaceletString()
                console.log("TEST: " + faceletString)

                if(faceletString === "ERROR - SIDE DUBLET") {
                    cubePane.state = "shadowWarning"
                    messageBar1.setMessage(false, "Würfel ist nicht gültig.");
                    messageBar2.setMessage(false, "Es existiert nicht genau eine Seite jeder Farbe.");
                }
                else if(faceletString === "ERROR - SIDES IMPOSSIBLE")  {
                    cubePane.state = "shadowWarning"
                    messageBar1.setMessage(false, "Würfel ist nicht gültig.");
                    messageBar2.setMessage(false, "Anordnung der Seiten ist nicht möglich.");
                }
                else if(faceletString === "ERROR - QUESTION MARKS")  {
                    console.log("enthält Fragezeichen")
                    cubePane.state = "shadowInvisible"
                    messageBar1.setMessage(false, "");
                    messageBar2.setMessage(false, "");
                }
                else {
                    console.log("->verifyCube")
                    twophaseAlgorithm.verifyCube(faceletString)
                }
            }
        }

    }

    TwophaseAlgorithm {
        id: twophaseAlgorithm;
        onTablesInitialized: consoleView.addLog("tables initialized (" + msecs + "ms)")

        onCubeSolved: {
            messageBar2.setMessage(true, "Lösung: \n" + solution)
            mainRect.cubeSolved(solution, msecs)
        }

        onCubeVerified: {
            console.log("onCubeVerified: result: " + result)
            switch(result) {
            case 0:
                cubePane.state = "shadowSuccess"
                messageBar1.setMessage(true, "Würfel ist gültig.");
                messageBar2.setMessage(true, "");

                twophaseAlgorithm.solveCube(cube.getFaceletString(), 22, 10000, 100);
                mainRect.cubeScanned()
                break;
            case 1:
                cubePane.state = "shadowWarning"
                messageBar1.setMessage(false, "Würfel ist nicht gültig.");
                messageBar2.setMessage(false, "Es existiert nicht genau eine Seite jeder Farbe.");
                break;
            case 2:
                cubePane.state = "shadowWarning"
                messageBar1.setMessage(false, "Würfel ist nicht gültig.");
                messageBar2.setMessage(false, "Es kommen nicht alle 12 Kanten vor.");
                break;
            case 3:
                cubePane.state = "shadowWarning"
                messageBar1.setMessage(false, "Würfel ist nicht gültig.");
                messageBar2.setMessage(false, "Eine Kante ist gekippt.");
                break;
            case 4:
                cubePane.state = "shadowWarning"
                messageBar1.setMessage(false, "Würfel ist nicht gültig.");
                messageBar2.setMessage(false, "Es kommen nicht alle 8 Ecken vor.");
                break;
            case 5:
                cubePane.state = "shadowWarning"
                messageBar1.setMessage(false, "Würfel ist nicht gültig.");
                messageBar2.setMessage(false, "Eine Ecke ist verdreht.");
                break;
            case 6:
                cubePane.state = "shadowWarning"
                messageBar1.setMessage(false, "Würfel ist nicht gültig.");
                messageBar2.setMessage(false, "Zwei Kanten oder zwei Ecken sind vertauscht.");
                break;
            case -1:
            default:
                cubePane.state = "shadowWarning"
                messageBar1.setMessage(false, "Würfel ist nicht gültig.");
                messageBar2.setMessage(false, "");
                break;
            }
        }

        Component.onCompleted: {
            twophaseAlgorithm.initTables()
            consoleView.addLog("start tables initialization...")
        }
    }


}
