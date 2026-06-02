import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PainAnalyzer 1.0
Page {
    id: page
    Keys.onEscapePressed: (e) => { e.accepted = true; win.goBack() }
    Keys.onBackPressed:   (e) => { e.accepted = true; win.goBack() }
    SelectionDialog {
        id: dlg
        parent: Overlay.overlay   // важно: не page.Window.overlay

        options: [
            {text: "Слезоточение на стороне боли"},
            {text: "Краснота глаза"},
            {text: "Сужение глазной щели"},
            {text: "Отек лица"},
            {text: "Выделения из носа"},
            {text: "Неприязнь к свету/звуку"},
            {text: "Тошнота/рвота"}
        ]
        onConfirmed: (items) => {
            PatientManager.setSymptoms(items)
            dlg.close()
            Qt.callLater(() => page.StackView.view.pop())
        }
    }

}