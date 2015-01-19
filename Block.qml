import QtQuick 2.0
import QtQuick.Particles 2.0

Rectangle {
    id: konoBlock
    signal selected
    width: 40
    height: 40
    radius: 20

    property alias state: konoBlock.state
    property int player: 1

    anchors.centerIn: parent
    color: "transparent"

    Image {
        source: player==1?"img/frog-nin1.png":"img/frog-nin2.png"
        rotation: player==1?180:0
        height: parent.height; width: parent.width
    }

    MouseArea {
        id: ma
        anchors.fill: parent
        onClicked: {
            selected();
            //sys.resume();
            toew.start();
            jumpjump.start();

        }

    }

    SequentialAnimation {
        id: jumpjump
        running: false
        loops: 15//Animation.Infinite
        NumberAnimation {
            target: konoBlock
            property: "y"
            to: y * -0.3
        }
        NumberAnimation {
            target: konoBlock
            property: "y"
            to: konoBlock.height / 2
        }
        onStarted: konoBlock.anchors.centerIn = undefined
    }

    ParallelAnimation {
        running: false
        id: toew
        NumberAnimation {
            target: konoBlock
            property: "rotation"
            from: 0
            to: 360
            duration: 1000
        }
    }

    SequentialAnimation {
        running: false
        id: doink
        NumberAnimation {
            target: konoBlock
            property: "scale"
            to: 3
        }
        NumberAnimation  {
            target: konoBlock
            property: "scale"
            to: 1
        }
        NumberAnimation  {
            target: konoBlock
            property: "rotation"
            to: 180
        }
    }

    Timer {
        id: thinking
        interval: 3000
        onTriggered: gotIt
    }

    signal gotIt
    function think(){
        thinking.start();
    }

    function doinkDoink() {
        doink.start();
    }

    function turnOn(){
        border.color= "red"
        border.width= 5
    }

    function turnOff(){
        border.color= "grey"
        border.width= 3
    }

    function activate(){
        enabled = true
    }

    function deactivate(){
        enabled = false
    }
}
