import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts
import PainAnalyzer 1.0
import Shared 1.0
Dialog {
    id: painDialog
    modal: true
    parent: Overlay.overlay
    anchors.centerIn: parent
    width: Math.min(parent.width * 0.9, 380)

    // Контент через Pane — у него есть padding
    contentItem: Pane {
        padding: 16

        ColumnLayout {
            spacing: 16
            width: parent.width

            Label {
                text: "Когда был текущий уровень боли?"
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
            }

            RadioButton {
                id: nowRadio
                text: "Сейчас"
                checked: true
                Layout.fillWidth: true
            }

            RadioButton {
                id: customRadio
                text: "Указать время"
                Layout.fillWidth: true
            }

            RowLayout {
                spacing: 10
                Layout.alignment: Qt.AlignHCenter
                visible: customRadio.checked

                TextField {
                    id: timeField
                    Layout.preferredWidth: 120
                    font.pixelSize: 20
                    horizontalAlignment: Text.AlignHCenter

                    inputMethodHints: Qt.ImhDigitsOnly
                    maximumLength: 5
                    text: "00:00"

                    property bool internalChange: false

                    onTextEdited: {
                        if (internalChange)
                            return

                        internalChange = true

                        // оставляем только цифры
                        var digits = text.replace(/[^0-9]/g, "")
                        if (digits.length > 4)
                            digits = digits.substring(0,4)

                        var h1 = digits.length > 0 ? parseInt(digits[0]) : 0
                        var h2 = digits.length > 1 ? parseInt(digits[1]) : 0
                        var m1 = digits.length > 2 ? parseInt(digits[2]) : 0
                        var m2 = digits.length > 3 ? parseInt(digits[3]) : 0

                        // ✅ Ограничение часов
                        if (digits.length >= 1 && h1 > 2)
                            h1 = 2

                        if (digits.length >= 2) {
                            if (h1 === 2 && h2 > 3)
                                h2 = 3
                        }

                        // ✅ Ограничение минут
                        if (digits.length >= 3 && m1 > 5)
                            m1 = 5

                        var result = ""

                        if (digits.length >= 1)
                            result += h1.toString()

                        if (digits.length >= 2)
                            result += h2.toString()

                        if (digits.length >= 3)
                            result += ":" + m1.toString()

                        if (digits.length === 4)
                            result += m2.toString()

                        text = result
                        cursorPosition = text.length

                        internalChange = false
                    }

                    // если пользователь стёр всё — вернуть 00:00
                    onEditingFinished: {
                        if (text.length < 5)
                            text = "00:00"
                    }
                }
            }
        }
    }

}