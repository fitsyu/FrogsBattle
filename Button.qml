import QtQuick 2.0

Rectangle {
    signal actionRequested
    property alias image: image.source
    id: root
    width: 200
    height: 80
    border { width: 5; color: "darkcyan" }
    color: "grey"
    radius: 15


    Image {
        id: image
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            swing.start()
            actionRequested()
        }
    }


    ParallelAnimation {
        id: swing
        running: false
        NumberAnimation {
            target: root
            property: "rotation"
            to: root.rotation * -1
            duration: 1000
            easing.type: Easing.InBounce
        }

        SequentialAnimation {
            NumberAnimation {
                target: root
                property: "scale"
                to:  3
            }
            NumberAnimation {
                target: root
                property: "scale"
                to: 1
            }
        }
    }

}
