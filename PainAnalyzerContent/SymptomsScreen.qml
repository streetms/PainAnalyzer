import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
Page {
    id: page
    SelectionDialog {
        id: dlg
        options: [
            {key: "a", text: "Слезоточение на стороне боли"},
            {key: "b", text: "Краснота глаза"},
            {key: "c", text: "Сужение глазной щели"},
            {key: "d", text: "Отек лица"},
            {key: "e", text: "Выделения из носа"},
            {key: "f", text: "Неприязнь к свету/звуку"}
        ]

        onConfirmed: (keys) => {
            console.log(keys)
            close()
        }
    }
}