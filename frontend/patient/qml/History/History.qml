import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Page {
    id: root
    signal backRequested()
    Keys.onEscapePressed: (e) => { e.accepted = true; win.goBack() }
    Keys.onBackPressed:   (e) => { e.accepted = true; win.goBack() }
    background: Rectangle {
        color: "#f3f4f6"
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 16
        anchors.margins: 20

        Rectangle {
            Layout.fillWidth: true
            height: 260
            radius: 20
            color: "#ffffff"
            border.width: 0

            Column {
                anchors.fill: parent
                anchors.margins: 20
                spacing: 10

                PainLevelGraph {
                    points:[
                        {x: 1, y: 7},
                        {x: 2, y: 8},
                        {x: 3, y: 9},
                        {x: 4, y: 10},
                        {x: 5, y: 8},
                        {x: 6, y: 9},
                        {x: 7, y: 6},
                        {x: 8, y: 3},
                        {x: 9, y: 5},
                        {x: 10, y: 6}
                    ]
                    minX: 1
                    maxX: 31
                }
            }
        }

        Label {
            text: "Прошлые записи"
            font.pixelSize: 22
            font.bold: true
            color: "#111827"
        }

        HistoryListView{
            modelData: historyModel
        }
        Button {
            text: "Назад"
            Layout.alignment: Qt.AlignHCenter
            width: 170
            height: 46

            background: Rectangle {
                radius: 23
                color: "#4a5580"
            }

            contentItem: Text {
                text: "Назад"
                color: "white"
                anchors.centerIn: parent
                font.pixelSize: 16
                font.bold: true
            }

            onClicked: root.backRequested()
        }
    }

    ListModel {
        id: historyModel

        ListElement {
            date: "Сегодня, 10 мая"
            pain: 6
            symptoms: "Головная боль, Усталость, Тошнота"
            triggers: "Стресс, Мало сна"
        }

        ListElement {
            date: "Вчера, 9 мая"
            pain: 5
            symptoms: "Тошнота, Светобоязнь"
            triggers: "Яркий свет"
        }

        ListElement {
            date: "8 мая"
            pain: 6
            symptoms: "Головная боль, Напряжение"
            triggers: "Работа за компьютером, Пропуск еды"
        }

        ListElement {
            date: "7 мая"
            pain: 4
            symptoms: "Усталость, Сонливость"
            triggers: "Недостаток воды"
        }

        ListElement {
            date: "6 мая"
            pain: 2
            symptoms: "Легкая головная боль"
            triggers: "Долгая дорога"
        }

        ListElement {
            date: "5 мая"
            pain: 7
            symptoms: "Головная боль, Тошнота"
            triggers: "Стресс"
        }
    }
}