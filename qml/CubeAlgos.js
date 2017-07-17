.pragma library

function getSides(colorArray, allSideColors) {
    var sides = "";
    for(var i = 0; i < 9; i++) {
        var faceletColor = colorArray[i];
        sides += getSideFromColor(faceletColor, allSideColors);
    }
    return sides;
}

function getSideFromColor(color, allSideColors) {
    switch(color) {
    case allSideColors[0]: return "U";
    case allSideColors[1]: return "R";
    case allSideColors[2]: return "F";
    case allSideColors[3]: return "D";
    case allSideColors[4]: return "L";
    case allSideColors[5]: return "B";
    }
    return "?";
}


function getAllSideColors(rightSideColor, backSideColor) {
    var topB_downG = ["yellow", "orange", "white", "red"];
    var topO_downR = ["yellow", "green", "white", "blue"];
    var topY_downW = ["orange", "blue", "red", "green"];

    var colors = ["?", rightSideColor, "?", "?" , "?", backSideColor]; //URFDLB

    for (var i = 0; i < 4; i++) {
        if(topB_downG[i%4] === rightSideColor && topB_downG[(i+1)%4] === backSideColor) {
            colors[4] = topB_downG[(i+2)%4]; // left
            colors[2] = topB_downG[(i+3)%4]; // front
            colors[0] = "blue"; // up
            colors[3] = "green"; // down
            break;
        }
        if(topB_downG[i%4] === backSideColor && topB_downG[(i+1)%4] === rightSideColor) {
            colors[4] = topB_downG[(i+3)%4]; // left
            colors[2] = topB_downG[(i+2)%4]; // front
            colors[0] = "green"; // up
            colors[3] = "blue"; // down
            break;
        }

        if(topO_downR[i%4] === rightSideColor && topO_downR[(i+1)%4] === backSideColor) {
            colors[4] = topO_downR[(i+2)%4]; // left
            colors[2] = topO_downR[(i+3)%4]; // front
            colors[0] = "orange"; // up
            colors[3] = "red"; // down
            break;
        }
        if(topO_downR[i%4] === backSideColor && topO_downR[(i+1)%4] === rightSideColor) {
            colors[4] = topO_downR[(i+3)%4]; // left
            colors[2] = topO_downR[(i+2)%4]; // front
            colors[0] = "red"; // up
            colors[3] = "orange"; // down
            break;
        }

        if(topY_downW[i%4] === rightSideColor && topY_downW[(i+1)%4] === backSideColor) {
            colors[4] = topY_downW[(i+2)%4]; // left
            colors[2] = topY_downW[(i+3)%4]; // front
            colors[0] = "yellow"; // up
            colors[3] = "white"; // down
            break;
        }
        if(topY_downW[i%4] === backSideColor && topY_downW[(i+1)%4] === rightSideColor) {
            colors[4] = topY_downW[(i+3)%4]; // left
            colors[2] = topY_downW[(i+2)%4]; // front
            colors[0] = "white"; // up
            colors[3] = "yellow"; // down
            break;
        }
    }
    return colors;
}

function contains(arr, obj) {
    for (var i = 0; i < arr.length; i++) {
        if (arr[i] === obj) {
            return true;
        }
    }
    return false;
}
