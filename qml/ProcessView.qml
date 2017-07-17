import QtQuick 2.2

Rectangle {
    width: 480
    height: 712 - 40
    color: "#4C4C4C"

    function resetAll() {
        setCubeScanned("waiting");
    }


    function setCubeScanned(progress) {
        if (progress === "finished") {
            scanCubeBar.state = "finished"
            scanCubeBar.text = "Würfel gescannt!"

            setSolutionComputed("running")
        }
        else if (progress === "running"){
            scanCubeBar.state = "running"
            scanCubeBar.text = "Würfel scannen..."

            setSolutionComputed("waiting")
        }
        else {
            scanCubeBar.state = "waiting"
            scanCubeBar.text = "Würfel scannen..."

            setSolutionComputed("waiting")
        }
    }

    function setSolutionComputed(progress, solution, msecs) {
        console.log("setSolutionComputed:" + progress)
        if (progress === "finished") {
            computeSolutionBar.state = "finished"
            computeSolutionBar.text = "Lösung berechnet! (" + msecs + " Millisekunden)\n"
            var numberOfMoves = solution.match(/[ULFRBD]/g).length;
            if(numberOfMoves === 1)
                computeSolutionBar.text += "Es ist 1 Zug nötig."
            else
                computeSolutionBar.text += "Es sind " + numberOfMoves + " Züge nötig."

            setMovesComputed("running")
        }
        else if (progress === "running"){
            computeSolutionBar.state = "running"
            computeSolutionBar.text = "Lösung berechnen..."

            setMovesComputed("waiting")
        }
        else {
            computeSolutionBar.state = "waiting"
            computeSolutionBar.text = "Lösung berechnen..."

            setMovesComputed("waiting")
        }
    }

    function setMovesComputed(progress) {
        if (progress === "finished") {
            computeMovesBar.state = "finished"
            computeMovesBar.text = "Greifbewegungen berechnet..."

            setCubeSolved("running")
        }
        else if (progress === "running"){
            computeMovesBar.state = "running"
            computeMovesBar.text = "Greifbewegungen berechnen..."

            setCubeSolved("waiting")
        }
        else {
            computeMovesBar.state = "waiting"
            computeMovesBar.text = "Greifbewegungen berechnen..."

            setCubeSolved("waiting")
        }
    }

    function setCubeSolved(progress) {
        if (progress === "finished") {
            solveCubeBar.state = "finished"
            solveCubeBar.text = "Würfel gelöst"
        }
        else if (progress === "running"){
            solveCubeBar.state = "running"
            solveCubeBar.text = "Würfel lösen..."
        }
        else {
            solveCubeBar.state = "waiting"
            solveCubeBar.text = "Würfel lösen..."
        }
    }

    Item {
        width: parent.width
        anchors.verticalCenter: parent.verticalCenter
        height: scanCubeBar.height + 10 + computeSolutionBar.height + 10 + computeMovesBar.height + 10 + solveCubeBar.height

        ProcessViewProgressBar {
            id: scanCubeBar
            width: parent.width
        }

        ProcessViewProgressBar {
            id: computeSolutionBar
            width: parent.width
            anchors.top: scanCubeBar.bottom
            anchors.topMargin: 10
        }

        ProcessViewProgressBar {
            id: computeMovesBar
            width: parent.width
            anchors.top: computeSolutionBar.bottom
            anchors.topMargin: 10
        }

        ProcessViewProgressBar {
            id: solveCubeBar
            width: parent.width
            anchors.top: computeMovesBar.bottom
            anchors.topMargin: 10
        }
    }

    Component.onCompleted: {
        setCubeScanned("running")
    }

}
