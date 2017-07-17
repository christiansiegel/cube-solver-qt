import QtQuick 2.2
import QtQuick.Controls 1.1
import QtMultimedia 5.0

import CubeSolverApp 1.0

Rectangle {
    width: 100
    height: 62

    TwophaseAlgorithm {
        id: twophaseAlgorithm;
        onTablesInitialized: middleText.text = qsTr("Tables initialized")
        onCubeSolved: middleText.text = solution
    }

    BluetoothClient {
        id: btClient

        Component.onCompleted: {
            console.log("Bluetooth connecting to 98:D3:31:B0:7F:3A ...")
            connectTo("98:D3:31:B0:7F:3A")
        }

        onTelegramReceived: console.log("Bluetooth received: " + telegram)
        onConnected: console.log("Bluetooth connectec to " + name + "(" + macAddress + ")")
        onDisconnected: console.log("Bluetooth disconnected")
        onError: console.log("Bluetooth error: " + errorMessage)
    }


    menuBar: MenuBar {
        Menu {
            title: qsTr("File")
            MenuItem {
                text: qsTr("Exit")
                onTriggered: Qt.quit();
            }
            MenuItem {
                text: qsTr("Init Tables")
                onTriggered: {
                    middleText.text = qsTr("initializing tables");
                    twophaseAlgorithm.initTables();
                }
            }
            MenuItem {
                text: qsTr("Solve Cube")
                onTriggered: {
                    middleText.text = qsTr("solving cube");
                    //twophaseAlgorithm.solveCube("RULFURRDFLDURRBRLFDFUFFURLUUBFBDDBRLBLFRLUDUBBLDDBBDFL", 21, 1000, 100);
                    twophaseAlgorithm.solveCube(cube.getFaceletString(), 21, 1000, 100);
                }
            }
            MenuItem {
                text: qsTr("get facelets")
                onTriggered: {
                    var faceletString = cube.getFaceletString();
                    middleText.text = faceletString;
                }
            }

            MenuItem {
                text: qsTr("set facelets to solved cube")
                onTriggered: {
                    cube.uColors = ["white", "white", "white", "white", "white", "white", "white", "white", "white"];
                    cube.fColors = ["green", "green", "green", "green", "green", "green", "green", "green", "green"];
                    cube.rColors = ["red", "red", "red", "red", "red", "red", "red", "red", "red"];
                    cube.bColors = ["blue", "blue", "blue", "blue", "blue", "blue", "blue", "blue", "blue"];
                    cube.lColors = ["orange", "orange", "orange", "orange", "orange", "orange", "orange", "orange", "orange"];
                    cube.dColors = ["yellow", "yellow", "yellow", "yellow", "yellow", "yellow", "yellow", "yellow", "yellow"];

                }
            }

            MenuItem {
                text: qsTr("reset Facelets to ?")
                onTriggered: {
                    cube.resetAllColors();

                }
            }

            MenuItem {
                text: qsTr("connect Bluetooth")
                onTriggered: {
                    btClient.connectTo("98:D3:31:B0:7F:3A")
                }
            }


        }
    }

    Text {
        id: middleText
        text: qsTr("Hello World")
        anchors.left: parent.left;
        anchors.top: cube.bottom;
    }

    VideoOutput {
        id: livePreview
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        width: 120
        height: 160
        source: camera

        //transform: Rotation { angle: 90; origin.x: parent.width / 2; origin.y: parent.height / 2}
        orientation: 270
        Camera {
            id: camera

            imageProcessing {
                whiteBalanceMode: CameraImageProcessing.WhiteBalanceTungsten
                denoisingLevel: -1
            }

        }

       Component.onCompleted: ImageProcessor.setCameraObject(camera)
    }



    Connections {
        target: ImageProcessor
        onProcessedImage: cube.setSide(side, facelets);
    }

    Cube {
        id: cube
        anchors.top: parent.top;
        anchors.left: parent.left;
        faceletSize: 30
    }

    QImageItem {
        id: processedImageView
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        width: 120
        height: 160
        image: ImageProcessor.processedImage
    }

    Torch {
        id: torch
        power: 75       // 75% of full power
        enabled: false   // On
    }

    Rectangle {
        anchors.top: middleText.bottom
        property bool active: false
        property string effectname: "torch"
        height: 60; width: 100; color: "gray"; radius: 5; border.color: "black"
        Rectangle {
        id: status
        height: 10; width: 10; anchors.top: parent.top; anchors.left: parent.left; anchors.topMargin: 10; anchors.leftMargin: 10
        color: active ? "green" : "red"
        }
        Text {
        anchors.verticalCenter: parent.verticalCenter; anchors.left: status.right; anchors.leftMargin: 5; text: effectname
        }
        MouseArea {
        anchors.fill: parent; onClicked: {
            console.out(camera.flash.mode);
            if(camera.flash.mode === Camera.FlashTorch)
                camera.flash.mode = Camera.FlashTorch;
            else
                camera.flash.mode = Camera.FlashOff;
        }
        }
}
