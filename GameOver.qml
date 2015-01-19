import QtQuick 2.0
import QtQuick.Particles 2.0

Rectangle {
    id: kotak
    property int winner: 0
    signal toMenu
    signal replay

    width: parent.width
    height: 60
    anchors.centerIn: parent

    color: Qt.darker("cyan")
    border { color: "black"; width: 3 }
    rotation: winner==1?15:195
    opacity: 0.8

    Rectangle {
        width: kotak.width; height: 30
        color: "black"
        opacity: 0.7
        anchors.centerIn: kotak
    }

    Row {
        anchors.centerIn: kotak
        Image {
            id: background
            width: 100; height: 100
            source: winner==1?"img/frog-nin1.png":"img/frog-nin2.png"
        }

        Text {
            y: 20
            color: "white"
            text: winner==1?"Player 1\nwins":"Player 2\nwins"
            font.pointSize: 20
            rotation: 15
        }
    }

    Rectangle {
        anchors.right: parent.left

        Text {
            text: "lame!"
            color: "white"
            rotation: 200
            font.pointSize: 16
        }
    }

    Row {
        anchors.bottom: kotak.bottom
        Button {
            width: 60; height: 30
            image: "img/Again.png"
            onActionRequested: { kotak.visible = false; replay(); emitter.enabled = false; }
        }
        Button {
            width: 60; height: 30
            image: "img/Menu.png"
            onActionRequested: { kotak.visible = false; toMenu(); emitter.enabled= false }
        }
    }


    NumberAnimation {
        id: kelar
        target: kotak
        property: "scale"
        from: 1/3
        to: 1
        duration: 1000
        running: false
        easing.type: Easing.OutBounce
    }

    function show(){
        visible = true
        kelar.start();
        emitter.enabled=true;
    }

    ParticleSystem {
        id: sys
        ImageParticle {
            source: "img/glowdot.png" //winner==1?"Light2.png":"Light1.png"
            system: sys
            colorVariation: 1
        }

        Emitter {
            id: emitter
            system: sys
            x: 3*(parent.parent.width/4)
            width: parent.width
            height: 100
            emitRate: 500
            lifeSpan: 2000
            lifeSpanVariation: 500
            size: 10
            endSize: 20
            velocity: AngleDirection {
                angle: 270; angleVariation: 15;
                magnitude: 300
            }
            acceleration: AngleDirection {
                angle: 105; angleVariation: 20;
                magnitude: 700
            }
            enabled: false
        }
    }

}
