import QtQuick 2.0
import QtQuick.Controls 1.1

Rectangle {
    id: helpRect
    width: parent.width
    height: parent.height
    color: "brown"
    Label {
        anchors.centerIn: parent
        text: "To win you get to have your player blocks\n" +
              "forms a row without being in your own place.\n" +
              "Enjoy!"
        color: "white"
    }
    z: 10
    MouseArea {
        anchors.fill: parent
        onClicked: { helpRect.visible=false }
    }
}
