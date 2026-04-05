import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Popup {
    id: root
    modal: true
    focus: true
    dim: true
    // ВАЖНО: центрируем относительно parent (обычно Overlay)
    function recenter() {
        if (!parent) return
        x = Math.round((parent.width  - width)  / 2)
        y = Math.round((parent.height - height) / 2)
    }

    onParentChanged: recenter()
    onWidthChanged: recenter()
    onHeightChanged: recenter()

    // если экран/ориентация поменялись, overlay тоже меняет размер
    Connections {
        target: root.parent
        function onWidthChanged()  { root.recenter() }
        function onHeightChanged() { root.recenter() }
    }

    // задайте нормальный размер окна (пример)
    width: Math.min(360, parent ? parent.width * 0.9 : 360)
    height: Math.min(520, parent ? parent.height * 0.7 : 520)
    // То, что вы хотите подменять снаружи:
    // [{ key: "...", text: "..." }, ...]
    property var options: []

    property var selectedKeys: []
    signal confirmed(var selectedKeys)

    function isSelected(key) { return selectedKeys.indexOf(key) !== -1 }
    function toggle(key) {
        const i = selectedKeys.indexOf(key)
        if (i === -1) selectedKeys = selectedKeys.concat([key])
        else {
            const copy = selectedKeys.slice(0)
            copy.splice(i, 1)
            selectedKeys = copy
        }
    }

    contentItem: Rectangle {
        radius: 22
        color: "#ECE8F0"

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 18
            spacing: 14

            ScrollView {
                id: sv
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true

                // чтобы контент не “плавал” по ширине
                contentWidth: availableWidth

                GridLayout {
                    id: grid
                    // ВАЖНО: ширина должна быть шириной viewport, а не parent.width
                    width: sv.availableWidth
                    columns: 2
                    columnSpacing: 16
                    rowSpacing: 16

                    // опционально: отступы внутри области со списком
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.margins: 2

                    Repeater {
                        model: root.options

                        delegate: Rectangle {
                            // заполняем ячейку и не даём “вылезать”
                            Layout.fillWidth: true
                            Layout.preferredHeight: 64
                            Layout.minimumWidth: 0

                            radius: 14
                            color: root.isSelected(modelData.key) ? "#D7D1DE" : "#ECE8F0"
                            border.width: 1
                            border.color: root.isSelected(modelData.key) ? "#6A64A8" : "#00000012"
                            clip: true

                            Text {
                                anchors.fill: parent
                                anchors.margins: 10
                                text: modelData.text
                                wrapMode: Text.WordWrap
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                elide: Text.ElideRight
                                color: "#2B2B2B"
                                font.pixelSize: 13
                            }

                            MouseArea {
                                anchors.fill: parent
                                onClicked: root.toggle(modelData.key)
                            }
                        }
                    }
                }
            }


            Button {
                text: "Подтвердить"
                onClicked: root.confirmed(root.selectedKeys)
            }
        }
    }
    Component.onCompleted:{
        console.log("open")
        dlg.open()
    }
}
