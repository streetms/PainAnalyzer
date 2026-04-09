import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
Page {
    property bool selectionMode: true
    id: page
    // anchors.fill: parent
    padding: 0

    property int painLevel: Math.round(painSlider.value) // 0..10

        signal backClicked

    signal saveClicked(var data)

    signal openRequested(string key)

    background: Rectangle {

        color: "#EFEFF2"
    }

    Flickable {
        anchors.fill: parent
        contentWidth: width
        contentHeight: content.implicitHeight + 24
        clip: true

        Column {
            id: content
            width: parent.width
            spacing: 18
            topPadding: 18
            bottomPadding: 90

            // ---------- Card 1 ----------
            Rectangle {
                width: parent.width - 36
                height: 172
                radius: 18
                 color: "#E6E1EA"
                 border.color: "#00000010"
                border.width: 1
                anchors.horizontalCenter: parent.horizontalCenter

                Column {
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 10

                    Text {
                        text: "Укажите уровень боли по 10-бальной шкале"
                        width: parent.width
                        wrapMode: Text.WordWrap
                        horizontalAlignment: Text.AlignHCenter
                        font.pixelSize: 16
                        font.weight: 700
                        color: "#1F1F24"
                    }

                    Text {
                        text: page.painLevel.toString()
                        width: parent.width
                        horizontalAlignment: Text.AlignHCenter
                        font.pixelSize: 18
                        font.weight: 700
                        color: "#1F1F24"
                    }

                    Item {
                        width: parent.width
                        height: 52

                        // Gradient track (rounded)
                        Rectangle {
                            id: track
                            x: 0
                            y: 8
                            width: parent.width
                            height: 26
                            radius: 13
                            gradient: Gradient {
                                orientation: Gradient.Horizontal
                                GradientStop {
                                    position: 0.0
                                    color: "#9BE07A"
                                }
                                GradientStop {
                                    position: 0.55
                                    color: "#E7D36A"
                                }
                                GradientStop {
                                    position: 1.0
                                    color: "#B9877F"
                                }
                            }
                        }

                        Slider {
                            id: painSlider
                            anchors.fill: track            // чтобы геометрия совпала с дорожкой
                            from: 0
                            to: 10
                            stepSize: 1
                            value: 5

                            // убираем свой фон, используем внешний track
                            background: Item { }

                            // важно: даём Slider'у правильную высоту
                            implicitHeight: track.height

                            handle: Rectangle {
                                height: 24
                                radius: 12
                                color: "#E00000"
                                border.width: 1
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: parent.left
                                anchors.right: parent.right
                                anchors.leftMargin: 274
                                anchors.rightMargin: 274
                                border.color: "#B3000059"

                                // ДВИЖЕНИЕ РУЧКИ:
                            }

                            onValueChanged: page.painLevel = Math.round(value)
                        }


                        Text {
                            text: "Слабая"
                            anchors.left: parent.left
                            anchors.leftMargin: 6
                            anchors.bottom: parent.bottom
                            font.pixelSize: 16
                            font.weight: 600
                            color: "#3A3A41"
                        }

                        Text {
                            text: "Сильная"
                            anchors.right: parent.right
                            anchors.rightMargin: 6
                            anchors.bottom: parent.bottom
                            font.pixelSize: 16
                            font.weight: 600
                            color: "#3A3A41"
                        }
                    }
                }
            }

            // ---------- Card 2 ----------
            Rectangle {
                width: parent.width - 36
                height: 420
                radius: 18
                color: "#E6E1EA"
                border.color: "#00000010"
                border.width: 1
                anchors.horizontalCenter: parent.horizontalCenter

                Column {
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 14

                    Text {
                        text: "Дополнительная информация"
                        width: parent.width
                        horizontalAlignment: Text.AlignHCenter
                        font.pixelSize: 18
                        font.weight: 800
                        color: "#1F1F24"
                    }

                    Rectangle {
                        width: parent.width
                        height: 300
                        radius: 24
                        color: "#DCD7E1"
                        opacity: 0.55

                        GridLayout {
                            anchors.fill: parent
                            anchors.margins: 18
                            columns: 2
                            rowSpacing: 16
                            columnSpacing: 14

                            Repeater {
                                model: [{
                                    "key": "type",
                                    "text": "Тип головной боли",
                                    "small": true
                                }, {
                                    "key": "head",
                                    "text": "Голова",
                                    "small": false
                                }, {
                                    "key": "triggers",
                                    "text": "Триггеры",
                                    "small": false
                                }, {
                                    "key": "auras",
                                    "text": "Ауры",
                                    "small": false
                                }, {
                                    "key": "symptoms",
                                    "text": "Симптомы",
                                    "small": false
                                }, {
                                    "key": "drugs",
                                    "text": "Лекарства",
                                    "small": false
                                }]

                                delegate: Button {
                                    Layout.fillWidth: true
                                    Layout.preferredHeight: 56

                                    text: modelData.text
                                    onClicked: page.openRequested(modelData.key)
                                    font.pixelSize: modelData.small ? 14 : 16
                                    font.weight: 500

                                    background: Rectangle {
                                        radius: 18
                                        color: "#F3F1F7"
                                        border.width: 1
                                        border.color: "#00000014"
                                    }

                                    contentItem: Text {
                                        text: parent.text
                                        anchors.centerIn: parent
                                        color: "#6A6677"
                                        font.pixelSize: parent.font.pixelSize
                                        font.weight: parent.font.weight
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                        elide: Text.ElideRight
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    // ---------- Bottom buttons ----------
    Rectangle {
        height: 86
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        color: "#EFEFF2"

        Row {
            spacing: 18
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter

            Button {
                width: 132
                height: 52
                text: "Назад"

                background: Rectangle {
                    radius: 26
                    color: "#515A86"
                }
                contentItem: Text {
                    text: parent.text
                    anchors.centerIn: parent
                    color: "white"
                    font.pixelSize: 16
                    font.weight: 700
                }
                //onClicked: page.backClicked()
            }

            Button {
                id:save
                width: 132
                height: 52
                text: "Сохранить"

                background: Rectangle {
                    radius: 26
                    color: "#515A86"
                }
                contentItem: Text {
                    text: parent.text
                    anchors.centerIn: parent
                    color: "white"
                    font.pixelSize: 16
                    font.weight: 700
                }
                onClicked:{
                    text =  "cохранено"
                }
            }
        }
    }
}
