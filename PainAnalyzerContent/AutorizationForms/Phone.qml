// FIO.qml
// Экран для StackView: карточка по центру + стрелки внизу.
// Qt Quick Controls 2 (Qt 5.15+/Qt 6.x)

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: root
    anchors.fill: parent
    signal openRequested(string key)
    signal backRequested()
    Keys.onEscapePressed: (e) => { e.accepted = true; win.goBack() }
    Keys.onBackPressed:   (e) => { e.accepted = true; win.goBack() }
    Rectangle {
        anchors.fill: parent
        color: "#FFFFFF"
    }

    Rectangle {
        id: card
        width: Math.min(420, root.width - 40)
        height: 285
        radius: 14
        color: "#E9E9EF"
        border.color: "#E2E2E8"
        border.width: 1

        anchors.centerIn: parent

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 18
            spacing: 12

            Item { Layout.fillWidth: true; Layout.preferredHeight: 6 }

            Label {
                Layout.alignment: Qt.AlignHCenter
                text: "Введите номер телефона"
                color: "#333333"
                font.pixelSize: 16
                font.weight: Font.Medium
            }

            TextField {
                anchors.centerIn: parent
                id: lastName
                Layout.fillWidth: true
                placeholderText: "телефон"
                text: ""
            }

            Item { Layout.fillWidth: true; Layout.fillHeight: true }
        }
    }

    // Нижние стрелки (приклеены к низу окна)
    Row {
        id: navRow
        spacing: 0
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.leftMargin: 28
        anchors.rightMargin: 28
        anchors.bottomMargin: 18
        height: 44

        ToolButton {
            id: backBtn
            width: 44
            height: 44
            background: Item {} // без фона/рамки
            contentItem: Text {
                text: "←"
                color: "#D63B3B"
                font.pixelSize: 22
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            onClicked: root.backRequested()
        }

        Item { width: 1; height: 1; anchors.verticalCenter: parent.verticalCenter }
        Item { anchors.verticalCenter: parent.verticalCenter; width: parent.width - (backBtn.width + nextBtn.width); height: 1 }

        ToolButton {
            id: nextBtn
            width: 44
            height: 44
            background: Item {}
            contentItem: Text {
                text: "→"
                color: "#D63B3B"
                font.pixelSize: 22
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            onClicked: {

                root.openRequested("FIO")
            }
        }
    }
}
