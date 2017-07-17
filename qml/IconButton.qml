import QtQuick 2.0

Rectangle {
    id: mainRect

    width: 48
    height: 48

    color: "#DD006E"
    property alias imageSource: iconImage.source

    function rotateIcon180 () {
        rotateAnimation.to = 180
        rotateAnimation.start()
    }

    Image {
        id: iconImage
        width: 40
        height: 40
        anchors.centerIn: parent
        fillMode: Image.PreserveAspectFit
        smooth: true
        source: "images/symbol_statistics.png"

        NumberAnimation on rotation {id: rotateAnimation; from: 0; to: 0; duration: 200}
    }
}
