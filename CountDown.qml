import QtQuick 2.0
import QtQuick.Window 2.2

Item {
    width: Screen.width
    height: Screen.height
    id: rect

    signal finished()

    Text {
        id: label
        x: 100; y: 100
        property int count: 1
        color: "white"
        font.pointSize: 30
        text: count

        SequentialAnimation {
            id: counting
            ParallelAnimation {
                NumberAnimation{
                    target: label
                    properties: "rotation"
                    to: label.rotation+360
                }
                NumberAnimation{
                    target: label
                    properties: "x,y"
                    to: label.x+180
                }
            }
            NumberAnimation{
                target: label
                properties: "scale"
                to: 10
                easing.type: "OutQuad"
                duration: 500
            }

            NumberAnimation{
                target: label
                properties: "scale"
                to: 1
                easing.type: "InQuad"
                duration: 500
            }


            running: false
            onStopped: {
                if (label.count < 3) {
                    start();
                    label.count++
                    label.text = label.count
                } else {
                    rect.visible = false;
                    label.count = 1;
                    label.text = label.count;
                    label.x = 100; label.y = 100;
                    finished() }
            }
        }
    }

    function start(){
        rect.visible = true;
        counting.start();
    }
}

