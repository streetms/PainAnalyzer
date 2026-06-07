import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
Page {
    id: root
    signal openRequested(string key)

    background: Rectangle {
        color: "#f3f4f6"
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 24
        spacing: 28

        Label {
            text: "Дневник боли"
            font.pixelSize: 34
            font.bold: true
            color: "#1f2937"
        }

        Item { Layout.fillHeight: true }

        ColumnLayout {
            spacing: 24
            Layout.fillWidth: true

            CardButton {
                title: "Добавить запись"
                subtitle: "Зафиксировать текущий уровень боли"
                gradientStart: "#e9ecff"
                gradientEnd: "#dff3e6"

                onClicked: root.openRequested("Record")
            }

            CardButton {
                title: "История"
                subtitle: "Посмотреть прошлые записи"
                gradientStart: "#f3e9ff"
                gradientEnd: "#ffe8c7"

                onClicked: root.openRequested("History")
            }
        }

        Item { Layout.fillHeight: true }
    }
}