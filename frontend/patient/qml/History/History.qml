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

        ListView {
            id: historyList
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 12
            clip: true
            model: historyModel

            delegate: Rectangle {
                width: historyList.width
                radius: 16
                color: "#ffffff"
                border.width: 0

                implicitHeight: contentColumn.implicitHeight + 32

                Column {
                    id: contentColumn
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.margins: 16
                    spacing: 8

                    Text {
                        text: date
                        font.bold: true
                        font.pixelSize: 16
                        color: "#111827"
                    }

                    Text {
                        text: "Уровень боли"
                        color: "#6b7280"
                        font.pixelSize: 13
                    }

                    Text {
                        text: pain + " / 10"
                        font.bold: true
                        font.pixelSize: 18
                        color: "#111827"
                    }

                    Item {
                        width: 200
                        height: 26

                        Slider {
                            id: painSlider
                            anchors.fill: parent
                            from: 0
                            to: 10
                            value: pain
                            enabled: false

                            background: Rectangle {
                                x: 0
                                y: parent.height/2 - 4
                                width: parent.width
                                height: 8
                                radius: 4

                                gradient: Gradient {
                                    orientation: Gradient.Horizontal
                                    GradientStop { position: 0.0; color: "#22c55e" }
                                    GradientStop { position: 0.5; color: "#eab308" }
                                    GradientStop { position: 1.0; color: "#ef4444" }
                                }
                            }

                            handle: Rectangle {
                                width: 16
                                height: 16
                                radius: 8
                                y: parent.height/2 - height/2
                                x: painSlider.visualPosition * (painSlider.availableWidth - width)

                                color: "#ef4444"
                                border.color: "white"
                                border.width: 2
                            }
                        }
                    }

                    Text {
                        text: "Симптомы"
                        color: "#6b7280"
                        font.pixelSize: 13
                    }

                    Flow {
                        width: parent.width
                        spacing: 6

                        Repeater {
                            model: symptoms.split(",")

                            delegate: Rectangle {
                                radius: 12
                                height: 26
                                color: "#f3f4f6"

                                Text {
                                    id: symptomText
                                    text: modelData.trim()
                                    anchors.centerIn: parent
                                    font.pixelSize: 12
                                    color: "#374151"
                                }

                                width: symptomText.paintedWidth + 20
                            }
                        }
                    }

                    Text {
                        text: "Триггеры"
                        color: "#6b7280"
                        font.pixelSize: 13
                    }

                    Flow {
                        width: parent.width
                        spacing: 6

                        Repeater {
                            model: triggers.split(",")

                            delegate: Rectangle {
                                radius: 12
                                height: 26
                                color: "#f3f4f6"

                                Text {
                                    id: triggerText
                                    text: modelData.trim()
                                    anchors.centerIn: parent
                                    font.pixelSize: 12
                                    color: "#374151"
                                }

                                width: triggerText.paintedWidth + 20
                            }
                        }
                    }
                }
            }
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