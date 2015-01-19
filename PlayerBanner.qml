import QtQuick 2.0
import QtQuick.Particles 2.0

Item {
    id: rect
    property int player: 0
    width: 200
    height: 60

    Text {
        id: label
        anchors.horizontalCenter: background.horizontalCenter
        anchors.top: background.top
        color: "white"
        text: ""
        font.pointSize: 20
    }

    Image {
        id: background
        width: rect.width; height: rect.height
        source: player==1?"img/player1.png":"img/player2.png"
        anchors.fill: rect
        fillMode: Image.PreserveAspectFit
    }

    SequentialAnimation {
        id: takeOver
        running: false
        NumberAnimation {
            target: rect
            property: "y"
            to: (rect.parent.height - rect.height)/ 2
        }

        NumberAnimation {
            target: rect
            property: "scale"
            to: 3
        }
        NumberAnimation {
            target: rect
            property: "rotation"
            to: rotation+35
            duration: 500
            easing.type: Easing.InOutElastic
        }
        NumberAnimation {
            target: rect
            property: "scale"
            to: 1
        }
        NumberAnimation {
            target: rect
            property: "rotation"
            to: rotation+360
        }
        NumberAnimation {
            target: rect
            property: "y"
            to: y
        }

        onStarted: { label.text = "GO !!"; emitter.burst(emitter.emitRate) }
        onStopped: { label.text = "";}
    }

    Timer {
        id: chotto
        interval: 1000
        repeat: false
        running: false
        onTriggered: { takeOver.start();  }
    }

    function takeTurn(){
        rect.anchors.horizontalCenter = undefined;
        rect.anchors.bottom = undefined;
        chotto.start();
    }


    ParticleSystem {
        id: sys
        ImageParticle {
            source: "img/glowdot.png"//player==1?"Light1.png":"Light2.png"
            system: sys
            color: player==1?Qt.lighter("green"):"orange"
            colorVariation: 0.7
        }

        Emitter {
            id: emitter
            system: sys
            width: rect.width
            height: rect.height
            emitRate: 1500
            lifeSpan: 1000
            lifeSpanVariation: 500
            size: 10
            endSize: 20
            velocity: AngleDirection {
                angle: 270; angleVariation: 30;
                magnitude: 200
            }
            acceleration: AngleDirection {
                angle: 90; angleVariation: 30;
                magnitude: 500
            }
            enabled: false
        }
    }
}
