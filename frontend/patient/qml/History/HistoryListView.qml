import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
ListView {
    id: historyList
    Layout.fillWidth: true
    Layout.fillHeight: true
    spacing: 12
    clip: true
    property var modelData   // 👈 принимаем модель извне

    model: modelData

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