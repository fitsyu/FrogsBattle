import QtQuick 2.0
import QtQuick.Particles 2.0

Rectangle {
    width: parent.width
    height: parent.height
    color: "brown"
    id: menu

    signal startGame(int playerCount)
    signal whoIsWho
    signal helpMe

    Row {
        anchors.centerIn: parent
        Column {
            spacing: 20
            Image {
                source: "img/frog-nin1.png"
                width: 100; height: 200
            }
            Image {
                source: "img/frog-nin2.png"
                width: 100; height: 200
            }
        }

        Column {
            spacing: 10
            Button {
                image: "img/OnePlayer.png";
                rotation: 27;
                onActionRequested: {
                    startGame(1);
                    hide();
                }
            }
            Button {
                image: "img/TwoPlayers.png";
                rotation: 37
                onActionRequested: {
                    startGame(2);
                    hide();
                }
            }
            Button {
                image: "img/Help.png";
                rotation: 47;
                onActionRequested: helpMe()
            }
            Button {
                image: "img/About.png"
                rotation: 57;
                onActionRequested: whoIsWho()
            }
            Button {
                image: "img/Exit.png"
                rotation: 67;
                onActionRequested: Qt.quit()
            }
        }
    }

    NumberAnimation {
        id: rollOut
        target: menu
        property: "x"
        to: parent.x
        duration: 2000
        running: false
        easing.type: Easing.InOutExpo
        onStarted: emitter.burst(emitter.emitRate)
    }

    NumberAnimation {
        id: rollIn
        target: menu
        property: "x"
        to: x-width
        duration: 2000
        running: false
        easing.type: Easing.InOutExpo
        onStarted: emitter.burst(emitter.emitRate)
    }

    function show(){
        visible = true;
        rollOut.start();
    }

    function hide(){
        rollIn.start();
    }

    ParticleSystem {
        id: sys
        anchors.right: parent.right
        ItemParticle {
            system: sys
            delegate: brownBall
            Component {
                id: brownBall
                Rectangle {
                    width: 10; height: 10
                    radius: 5
                    color: "white"
                }
            }
        }

        Emitter {
            id: emitter
            system: sys
            height: menu.height
            emitRate: 100
            lifeSpan: 1000
            lifeSpanVariation: 200
            size: 10
            endSize: 20
            velocity: AngleDirection {
                angle: 0; angleVariation: 360
                magnitude: 50; magnitudeVariation: 150
            }

            enabled: false
        }
    }
}
