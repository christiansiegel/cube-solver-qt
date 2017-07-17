import QtQuick 2.0

Rectangle {
    width: faceletSize * 3
    height: faceletSize * 3

    property var sideColors: ["gray", "gray", "gray", "gray", "gray", "gray", "gray", "gray", "gray"]
    property int faceletSize: 20

    Grid {
        anchors.fill: parent;
        rows: 3;
        columns: 3;
        spacing: 0
        Repeater {
            model: 9
            Rectangle {
                width: faceletSize
                height: faceletSize
                color: sideColors[index]
                Behavior on color { ColorAnimation { duration: 100 } }
                border.color: "black"
                border.width: 1
                Text {
                    anchors.centerIn: parent;
                    font.pixelSize: faceletSize / 2;
                    color: "black"
                    opacity: sideColors[index] === "gray" ? 1 : 0
                    Behavior on opacity { NumberAnimation { duration: 100 } }
                    text: "?";
                }
            }
        }
    }
}
