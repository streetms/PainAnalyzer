import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Page {
    id: page
    // focus: true
    // Component.onCompleted: page.forceActiveFocus()

    // Keys.onBackPressed: (event) => { event.accepted = true; goBack() }
    // Keys.onEscapePressed: (event) => { event.accepted = true; goBack() }
    //
    Keys.onEscapePressed: (e) => { e.accepted = true; win.goBack() }
    Keys.onBackPressed:   (e) => { e.accepted = true; win.goBack() }
    SelectionDialog {
        id: dlg
        parent: Overlay.overlay   // важно: не page.Window.overlay

        options: [
            {text: "пульсирует"},
            {text: "распирает"},
            {text: "сжимает"},
            {text: "ноет"},
            {text: "простреливает"},
            {text: "жжет"},
            {text: "колет иглами"},
        ]

        onConfirmed: (text) => {
            currentRecord.setTriggers(text)
            dlg.close()
            Qt.callLater(() => page.StackView.view.pop())
        }
    }
}
