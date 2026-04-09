import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
Page {
    id: page
    Keys.onEscapePressed: (e) => { e.accepted = true; win.goBack() }
    Keys.onBackPressed:   (e) => { e.accepted = true; win.goBack() }
    SelectionDialog {
        id: dlg
        options: [
            {text: "Слезоточение на стороне боли"},
            {text: "Краснота глаза"},
            {text: "Сужение глазной щели"},
            {text: "Отек лица"},
            {text: "Выделения из носа"},
            {text: "Неприязнь к свету/звуку"},
            {text: "Тошнота/рвота"}
        ]
    }
}