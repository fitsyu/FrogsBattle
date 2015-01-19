import QtQuick 2.0
import QtQuick.Controls 1.1

Rectangle {
    id: aboutRect
    width: parent.width
    height: parent.height
    color: "brown"
    Label {
        anchors.centerIn: parent
        text: "Programming & Design \t: Fitsyu\n"+
              "Music                \t: Wioko"
        color: "white"
    }
    z: 10
    MouseArea {
        anchors.fill: parent
        onClicked: { aboutRect.visible=false }
    }
}
