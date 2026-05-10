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
            Layout.alignment: Qt.AlignLeft
        }

        Item { Layout.fillHeight: true }

        ColumnLayout {
            spacing: 24
            Layout.fillWidth: true

            Button {
                id: addButton
                Layout.fillWidth: true
                Layout.preferredHeight: 150
                background: Rectangle {
                    radius: 22
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: "#e9ecff" }
                        GradientStop { position: 1.0; color: "#dff3e6" }
                    }
                    layer.enabled: true
                    layer.effect: MultiEffect {
                        shadowEnabled: true
                        shadowBlur: 0.6
                        shadowColor: "#40000000"
                        shadowVerticalOffset: 6
                    }
                }

                contentItem: RowLayout {
                    anchors.fill: parent
                    anchors.margins: 24

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 6

                        Label {
                            text: "Добавить запись"
                            font.pixelSize: 22
                            font.bold: true
                            color: "#1f2937"
                        }

                        Label {
                            text: "Зафиксировать текущий уровень боли"
                            font.pixelSize: 16
                            color: "#6b7280"
                            wrapMode: Text.WordWrap
                        }
                    }

                }

                onClicked: root.openRequested("Record")
            }

            Button {
                id: historyButton
                Layout.fillWidth: true
                Layout.preferredHeight: 150

                background: Rectangle {
                    radius: 22
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: "#f3e9ff" }
                        GradientStop { position: 1.0; color: "#ffe8c7" }
                    }
                    layer.enabled: true
                    layer.effect: MultiEffect {
                        shadowEnabled: true
                        shadowBlur: 0.6
                        shadowColor: "#40000000"
                        shadowVerticalOffset: 6
                    }
                }

                contentItem: RowLayout {
                    anchors.fill: parent
                    anchors.margins: 24

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 6

                        Label {
                            text: "История"
                            font.pixelSize: 22
                            font.bold: true
                            color: "#1f2937"
                        }

                        Label {
                            text: "Посмотреть Прошлые записи"
                            font.pixelSize: 16
                            color: "#6b7280"
                            wrapMode: Text.WordWrap
                        }
                    }

                }

                onClicked: root.openRequested("History")
            }
        }

        Item { Layout.fillHeight: true }
    }
}