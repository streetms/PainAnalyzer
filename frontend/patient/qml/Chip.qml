
import QtQuick 2.15

Rectangle {
    id: chip
    height: textItem.implicitHeight + 10
    width: textItem.implicitWidth + 20
    radius: 14

    property string text: ""
    property bool selected: false

    signal clicked(bool isSelected)

    color: selected ? "#BFD3FF" : "#E6E6E6"

    Text {
        id: textItem
        text: chip.text
        anchors.centerIn: parent
        font.pixelSize: 14
        color: "#333"
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            chip.selected = !chip.selected
            chip.clicked(chip.selected)
        }
    }
}
