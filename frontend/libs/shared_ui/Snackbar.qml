import QtQuick
import QtQuick.Controls

Popup {
    id: root
    width: parent ? parent.width * 0.9 : 300
    height: implicitHeight

    x: (parent.width - width) / 2
    y: parent.height - height - 24

    padding: 16
    modal: false
    focus: false
    closePolicy: Popup.NoAutoClose

    property int duration: 3000

    background: Rectangle {
        radius: 12
        color: "#323232"
    }

    contentItem: Label {
        id: label
        text: root.text
        color: "white"
        wrapMode: Text.WordWrap
    }

    property string text: ""

    function show(message) {
        text = message
        open()
        timer.restart()
    }

    Timer {
        id: timer
        interval: root.duration
        onTriggered: root.close()
    }
}
