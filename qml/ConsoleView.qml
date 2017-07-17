import QtQuick 2.0

Rectangle {
    id: mainRect
    width: 480
    height: 712 - 40
    color: "#4C4C4C"

    clip: true

    function addLog(msg, color) {
        if(typeof(color)==='undefined') color = "black";

        var date = new Date();
        var time = pad(date.getHours(), 2) + ":" + pad(date.getMinutes(), 2) + ":" + pad(date.getSeconds(), 2)

        logModel.append({"time": time, "logMsg": msg, "color": color})
        logList.positionViewAtEnd()
    }

    function pad(num, size) {
        var s = num+"";
        while (s.length < size) s = "0" + s;
        return s;
    }

    ListView {
        id: logList
        anchors.centerIn: parent
        width: parent.width - 20
        height: parent.height - 20



        model: ListModel { id: logModel }
        delegate: logDelegate
    }

    ScrollBar {
         id: verticalScrollBar
         width: 10; height: logList.height
         anchors.right: logList.right
         anchors.verticalCenter: logList.verticalCenter
         orientation: Qt.Vertical
         position: logList.visibleArea.yPosition
         pageSize: logList.visibleArea.heightRatio

         opacity: (logList.moving === true) ? 1 : 0
         Behavior on opacity { NumberAnimation { duration: 100 } }
     }

    /*Component.onCompleted: {
        // test data:
        for(var i = 0; i < 100; ++i)
            addLog("test log " + i)
    }*/

    Component {
        id: logDelegate
        Item {
            width: logList.width
            height:msgText.height
            Text {
                id: timeText
                anchors.left: parent.left
                anchors.top: parent.top

                font.pixelSize: 18
                font.family: "Droid Sans"

                wrapMode: Text.WordWrap
                text: model.time
                color: model.color
            }

            Text {
                id: msgText
                anchors.left: timeText.right
                anchors.leftMargin: 5
                anchors.right: parent.right
                anchors.top: parent.top

                font.pixelSize: 18
                font.family: "Droid Sans"

                wrapMode: Text.WordWrap
                text: model.logMsg
                color: model.color
            }
        }
    }
}
