import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Shared 1.0

ListView {
    id: historyList
    Layout.fillWidth: true
    Layout.fillHeight: true
    spacing: 12
    clip: true
    property var modelData

    model: modelData
    section.property: "sectionDate"
    section.criteria: ViewSection.FullString

    component TagSection: Column {
        id: tagRoot
        property string title
        property var rawData

        // Вся грязная логика очистки строк живет только здесь
        property var parsedTags: {
            if (!rawData || String(rawData).trim() === "") return [];
            if (Array.isArray(rawData)) return rawData;

            return String(rawData).split(",")
                .map(s => s.trim())
                .filter(s => s.length > 0);
        }

        width: parent ? parent.width : 0
        spacing: 8
        visible: parsedTags.length > 0 // Скрываем весь блок, если нет тегов

        Text {
            text: tagRoot.title
            color: "#6b7280"
            font.pixelSize: 13
        }

        Flow {
            width: parent.width
            spacing: 6

            Repeater {
                model: tagRoot.parsedTags

                delegate: Rectangle {
                    radius: 12
                    height: 26
                    color: "#f3f4f6"

                    Text {
                        id: tagText
                        text: modelData
                        anchors.centerIn: parent
                        font.pixelSize: 12
                        color: "#374151"
                    }
                    width: tagText.paintedWidth + 20
                }
            }
        }
    }
    // ==========================================

    section.delegate: Component {
        Item {
            width: historyList.width
            height: 40

            Text {
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 8
                text: section
                font.bold: true
                font.pixelSize: 18
                color: "#111827"
            }
        }
    }

    delegate: Rectangle {
        id: episodeCard
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

            Item {
                width: parent.width
                height: 16

                Text {
                    anchors.left: parent.left
                    text: "Уровень боли"
                    color: "#6b7280"
                    font.pixelSize: 13
                }

                Text {
                    anchors.right: parent.right
                    text: typeof timeString !== "undefined" ? timeString : ""
                    color: "#9ca3af"
                    font.pixelSize: 13
                    font.bold: true
                }
            }

            Text {
                text: typeof intensity !== "undefined" ? intensity + " / 10" : "0 / 10"
                font.bold: true
                font.pixelSize: 18
                color: "#111827"
            }

            Item {
                width: 200
                height: 26

                PainSlider {
                    id: painSlider
                    value: typeof intensity !== "undefined" ? intensity : 0
                    enabled: false
                    radius: 10
                }
            }
            TagSection { title: "Симптомы"; rawData: typeof symptoms !== "undefined" ? symptoms : null }
            TagSection { title: "Триггеры"; rawData: typeof triggers !== "undefined" ? triggers : null }
            TagSection { title: "Ауры"; rawData: typeof auras !== "undefined" ? auras : null }
            TagSection { title: "Тип боли"; rawData: typeof types !== "undefined" ? types : null }

        }
    }
}