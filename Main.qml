import QtQuick 2.2
//import "qrc:///JavaChess.js" as JavaChess
import QtQuick.Window 2.2
//import Qt.labs.gestures 1.0
import QtMultimedia 5.0
import QtSensors 5.0

Window {
    objectName: "screen"
    id : root
    width: Screen.width; height: Screen.height
    visible: true
    visibility: "FullScreen"

//    TODO: create close dialog
//    onClosing: { close.accepted = false }
    Item {
        width: parent.width
        anchors { top: parent.top; bottom: parent.bottom }

        Image {
            id: background
            anchors.fill: parent
//            source: "img/treeatmyhome.jpg"
            source: "img/Glow_wall.jpg"
            fillMode: Image.PreserveAspectCrop
        }
    }

    Rectangle {
        objectName: "board"
        id: board
        anchors.centerIn: parent
        width: 400
        height: 400
        color: "black"
        opacity: 0.6


        Grid {

            columns: 5
//            spacing: 50
            anchors.centerIn: parent


            Place { objectName: "place1"; id:place1 ; text: ""; onSelected: GameEngine.moveTo(objectName); }
            Branch {}
            Place { objectName: "place2"; id:place2 ; text: ""; onSelected: GameEngine.moveTo(objectName)}
            Branch {}
            Place { objectName: "place3"; id:place3 ; text: ""; onSelected: GameEngine.moveTo(objectName)}

            Branch { rotation: 90 }
            Branch { rotation: 45 }
            Branch { rotation: 90 }
            Branch { rotation: 135}
            Branch { rotation: 90 }

            Place { objectName: "place4"; id:place4 ; text: "";
                onSelected: GameEngine.moveTo(objectName);
            }
            Branch {}
            Place { objectName: "place5"; id:place5 ; text: ""; onSelected: GameEngine.moveTo(objectName);}
            Branch {}
            Place { objectName: "place6"; id:place6 ; text: ""; onSelected: GameEngine.moveTo(objectName); }

            Branch { rotation: 90 }
            Branch { rotation: -45 }
            Branch { rotation: 90 }
            Branch { rotation: -135 }
            Branch { rotation: 90 }

            Place { objectName: "place7"; id:place7 ; text: ""; onSelected: GameEngine.moveTo(objectName); }
            Branch {}
            Place { objectName: "place8"; id:place8 ; text: ""; onSelected: GameEngine.moveTo(objectName); }
            Branch {}
            Place { objectName: "place9"; id:place9 ; text: ""; onSelected: GameEngine.moveTo(objectName); }
        }

        Grid {
            id: blockers
            columns: 2
            spacing: 65
            anchors.centerIn: parent
            Chain { rotation: 45 }
            Chain { rotation: 135 }
            Chain { rotation: -45 }
            Chain { rotation: -135 }
        }

    }

    PlayerBanner {
        objectName: "banner1";
        id: banner1
        player: 1

//        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.leftMargin: 100
    }

    PlayerBanner {
        objectName: "banner2";
        id: banner2
        player: 2

        rotation: 180

        anchors.right: parent.right
        anchors.rightMargin: 100
    }

    GameOver {
            objectName: "gameover"
            id: gameover;
            visible: false;
            onToMenu: {
//                JavaChess.cleanUp();
                GameEngine.cleanUp();
                menu.show();
            }
            onReplay: {
                GameEngine.cleanUp()
                counter.start()
                replayDelay.start()
            }

            Timer {
                id: replayDelay
                interval: 3000
                repeat: false
                onTriggered: GameEngine.replayGame()
            }
    }
    About { id: about; visible: false }
    Help { id: help; visible: false }
    Menu {
        id: menu
        property int playerAmount
        onStartGame: {
//            JavaChess.newGame(playerCount);
            playerAmount = playerCount
            delay0.start()
        }
        Timer {
            id: delay0
            repeat: false
            interval: 2000
            onTriggered: { counter.start(); delay.start() }
        }
        Timer {
            id: delay
            repeat: false
            interval: 3000
            onTriggered: {
                GameEngine.newGame( menu.playerAmount );
                theme.play()
            }
        }

        onWhoIsWho: about.visible= true
        onHelpMe: help.visible= true
    }

    CountDown { id: counter; visible: false }

    MediaPlayer {
        id: theme
        source: "music/theme.ogg"
        loops: MediaPlayer.Infinite
    }


//    GestureArea {
//          id: sensorGesture
//          onSwipe:  {
//              detectedAngle.text = sensorGesture.swipeAngle
//          }
//      }
//      Text {
//          id: detectedAngle
//          x:50
//          y:60
//          color: "white"
//          text: "swipe angle"
//      }
    SensorGesture {
        id: sensorGesture
        enabled: true
        gestures : availableGestures//["QtSensors.shake", "QtSensors.SecondCounter"]
        onDetected:{
            detectedText.text = gesture
            console.log(availableGestures)
        }
//        QtSensors.cover,
//        QtSensors.doubletap,
//        QtSensors.hover,
//        QtSensors.freefall,
//        QtSensors.pickup,
//        QtSensors.shake2,
//        QtSensors.slam,
//        QtSensors.turnover,
//        QtSensors.twist,
//        QtSensors.whip,
//        QtSensors.shake

    }
    Text {
        id: detectedText
        color: "white"
        font.pointSize: 20
        text: "G"
    }
}
