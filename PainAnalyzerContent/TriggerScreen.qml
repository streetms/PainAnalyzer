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
            {key: "a", text: "прикосновение к лицу"},
            {key: "b", text: "чистка зубов"},
            {key: "c", text: "Разговор"},
            {key: "d", text: "Ветер"},
            {key: "e", text: "Широкое открывание рта"},
            {key: "f", text: "Прием пищи/жевание"}
        ]

        onConfirmed: (keys) => {
            console.log(keys)
            dlg.close()
            Qt.callLater(() => page.StackView.view.pop())
        }
    }
}