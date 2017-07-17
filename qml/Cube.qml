import QtQuick 2.0
import "CubeAlgos.js" as CubeLib

Item {
    width: faceletSize * 12
    height: faceletSize * 9

    property int faceletSize: 30

    property var rColors: ["gray", "gray", "gray", "gray", "gray", "gray", "gray", "gray", "gray"]
    property var bColors: ["gray", "gray", "gray", "gray", "gray", "gray", "gray", "gray", "gray"]
    property var lColors: ["gray", "gray", "gray", "gray", "gray", "gray", "gray", "gray", "gray"]
    property var fColors: ["gray", "gray", "gray", "gray", "gray", "gray", "gray", "gray", "gray"]
    property var dColors: ["gray", "gray", "gray", "gray", "gray", "gray", "gray", "gray", "gray"]
    property var uColors: ["gray", "gray", "gray", "gray", "gray", "gray", "gray", "gray", "gray"]

    function resetAllColors() {
        rColors = ["gray", "gray", "gray", "gray", "gray", "gray", "gray", "gray", "gray"];
        bColors = ["gray", "gray", "gray", "gray", "gray", "gray", "gray", "gray", "gray"];
        lColors = ["gray", "gray", "gray", "gray", "gray", "gray", "gray", "gray", "gray"];
        fColors = ["gray", "gray", "gray", "gray", "gray", "gray", "gray", "gray", "gray"];
        dColors = ["gray", "gray", "gray", "gray", "gray", "gray", "gray", "gray", "gray"];
        uColors = ["gray", "gray", "gray", "gray", "gray", "gray", "gray", "gray", "gray"];
    }

    function getFaceletString() {
        var rightSideColor = rColors[4];
        var backSideColor = bColors[4];

        //console.log(rightSideColor);
        //console.log(backSideColor);

        if(CubeLib.contains(rColors, "gray")
        || CubeLib.contains(bColors, "gray")
        || CubeLib.contains(lColors, "gray")
        || CubeLib.contains(fColors, "gray")
        || CubeLib.contains(dColors, "gray")
        || CubeLib.contains(uColors, "gray"))
            return "ERROR - QUESTION MARKS"

        if(rightSideColor === backSideColor)
            return "ERROR - SIDE DUBLET";

        var allSideColors = CubeLib.getAllSideColors(rightSideColor, backSideColor);

        console.log("getFaceletString-allSideColors: " + allSideColors);

        if(CubeLib.contains(allSideColors, "?"))
            return "ERROR - SIDES IMPOSSIBLE"

        var faceletString = CubeLib.getSides(uColors, allSideColors);
        faceletString += CubeLib.getSides(rColors, allSideColors);
        faceletString += CubeLib.getSides(fColors, allSideColors);
        faceletString += CubeLib.getSides(dColors, allSideColors);
        faceletString += CubeLib.getSides(lColors, allSideColors);
        faceletString += CubeLib.getSides(bColors, allSideColors);

        console.log("getFaceletString-faceletString: " + faceletString);

        if(CubeLib.contains(faceletString, "?"))
            return "ERROR - QUESTION MARKS"

        return faceletString;
    }

    function rotateUp() {
        uColors = rotateFace(uColors);

        for(var i = 0; i < 3; ++i) {
            var tmp = fColors[i];
            fColors[i] = rColors[i];
            rColors[i] = bColors[i];
            bColors[i] = lColors[i];
            lColors[i] = tmp;
        }
    }

    function rotateUpInv() {
        uColors = rotateFaceInv(uColors);

        for(var i = 0; i < 3; ++i) {
            var tmp = fColors[i];
            fColors[i] = lColors[i];
            lColors[i] = bColors[i];
            bColors[i] = rColors[i];
            rColors[i] = tmp;
        }
    }

    function rotateFront() {
        fColors = rotateFace(fColors);

        for(var i = 0; i < 3; ++i) {
            var tmp = fColors[i];
            fColors[i] = rColors[i];
            rColors[i] = bColors[i];
            bColors[i] = lColors[i];
            lColors[i] = tmp;
        }
    }

    function rotateFace(face) {
        var tmp = face[2];
        face[2] = face[0];
        face[0] = face[6];
        face[6] = face[8];
        face[8] = tmp;

        tmp = face[1];
        face[1] = face[3];
        face[3] = face[7];
        face[7] = face[5];
        face[5] = tmp;

        return face;
    }

    function rotateFaceInv(face) {
        var tmp = face[0];
        face[0] = face[2];
        face[2] = face[8];
        face[8] = face[6];
        face[0] = tmp;

        tmp = face[1];
        face[1] = face[5];
        face[5] = face[7];
        face[7] = face[3];
        face[3] = tmp;

        return face;
    }

    function setSide(side, facelets){
        var colors = faceletsToColorArray(facelets);
        switch(side) {
        case "U": uColors = colors; break;
        case "D": dColors = colors; break;
        case "F": fColors = colors; break;
        case "R": rColors = colors; break;
        case "B": bColors = colors; break;
        case "L": lColors = colors; break;
        }
    }

    function faceletsToColorArray(facelets) {
        var colors = [];
        for (var i = 0; i < facelets.length; i++) {
            switch(facelets[i]) {
            case "R": colors[i] = "red"; break;
            case "G": colors[i] = "green"; break;
            case "B": colors[i] = "blue"; break;
            case "W": colors[i] = "white"; break;
            case "Y": colors[i] = "yellow"; break;
            case "O": colors[i] = "orange"; break;
            default: colors[i] = "gray";
            }
        }
        return colors;
    }

    CubeSide {
        id: upSide
        anchors.top: parent.top
        anchors.left: leftSide.right
        sideColors: parent.uColors
        faceletSize: parent.faceletSize

        MouseArea {
            anchors.fill: parent
            onClicked: ImageProcessor.captureImage("U")
        }
    }
    CubeSide {
        id: leftSide
        anchors.top: upSide.bottom
        anchors.left: parent.left
        sideColors: parent.lColors
        faceletSize: parent.faceletSize

        MouseArea {
            anchors.fill: parent
            onClicked: ImageProcessor.captureImage("L")
        }
    }
    CubeSide {
        id: frontSide
        anchors.top: upSide.bottom
        anchors.left: leftSide.right
        sideColors: parent.fColors
        faceletSize: parent.faceletSize

        MouseArea {
            anchors.fill: parent
            onClicked: ImageProcessor.captureImage("F")
        }
    }
    CubeSide {
        id: rigthSide
        anchors.top: upSide.bottom
        anchors.left: frontSide.right
        sideColors: parent.rColors
        faceletSize: parent.faceletSize

        MouseArea {
            anchors.fill: parent
            onClicked: ImageProcessor.captureImage("R")
        }
    }
    CubeSide {
        id: backSide
        anchors.top: upSide.bottom
        anchors.left: rigthSide.right
        sideColors: parent.bColors
        faceletSize: parent.faceletSize

        MouseArea {
            anchors.fill: parent
            onClicked: ImageProcessor.captureImage("B")
        }
    }
    CubeSide {
        id: downSide
        anchors.top: frontSide.bottom
        anchors.left: frontSide.left
        sideColors: parent.dColors
        faceletSize: parent.faceletSize

        MouseArea {
            anchors.fill: parent
            onClicked: ImageProcessor.captureImage("D")
        }
    }
}
