import QtQuick 2.0
import QtQuick.Particles 2.0

Rectangle {
    id: konoBasho

    signal selected

    property bool filled: false
    property alias text: label.text

    width: 80
    height: 80
    color: "transparent"
//    radius: 15
//    border { color: "darkorange"; width: 5 }

    Image {
        anchors.centerIn: parent
        source: "img/Wood.png"
        fillMode: Image.PreserveAspectCrop
        width: parent.width
        height: parent.height
    }

    MouseArea {
        anchors.fill: parent
        onClicked: selected();
    }

    Text {
        id: label
        anchors.centerIn: parent
    }



    ParticleSystem { id: sys }
    ImageParticle {
        system: sys
        source: "img/glowdot.png"
        color: "cyan"
        alpha: 0
        SequentialAnimation on color {
            loops: Animation.Infinite
            ColorAnimation {
                from: "cyan"
                to: "magenta"
                duration: 1000
            }
            ColorAnimation {
                from: "magenta"
                to: "blue"
                duration: 2000
            }
            ColorAnimation {
                from: "blue"
                to: "violet"
                duration: 2000
            }
            ColorAnimation {
                from: "violet"
                to: "cyan"
                duration: 2000
            }
        }
        colorVariation: 0.3
    }
    //! [0]
    Emitter {
        id: trailsNormal
        system: sys
        enabled: false

        emitRate: 500
        lifeSpan: 2000

        y: circle.cy
        x: circle.cx

        velocity: PointDirection {xVariation: 4; yVariation: 4;}
        acceleration: PointDirection {xVariation: 10; yVariation: 10;}
        velocityFromMovement: 8

        size: 8
        sizeVariation: 4
    }

    Item {
        id: circle
        //anchors.fill: parent
        property real radius: 0
        property real dx: konoBasho.width / 2
        property real dy: konoBasho.height / 2
        property real cx: radius * Math.sin(percent*6.283185307179) + dx
        property real cy: radius * Math.cos(percent*6.283185307179) + dy
        property real percent: 0

        SequentialAnimation on percent {
            loops: Animation.Infinite
            running: true
            NumberAnimation {
            duration: 1000
            from: 1
            to: 0
            loops: 8
            }
            NumberAnimation {
            duration: 1000
            from: 0
            to: 1
            loops: 8
            }

        }

        SequentialAnimation on radius {
            loops: Animation.Infinite
            running: true
            NumberAnimation {
                duration: 4000
                from: 0
                to: 50
            }
            NumberAnimation {
                duration: 4000
                from: 50
                to: 0
            }
        }
    }
    function guideHere(){
        trailsNormal.pulse(1000);
    }
}
