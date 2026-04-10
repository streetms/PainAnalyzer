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
            {text: "прикосновение к лицу"},
            {text: "чистка зубов"},
            {text: "Разговор"},
            {text: "Ветер"},
            {text: "Широкое открывание рта"},
            {text: "Прием пищи/жевание"},
            {text: "глотание"},
            {text: "нарушение режима сна"},
            {text: "алкоголь"},
            {text: "менструация"},
            {text: "стресс"},
            {text: "голод"},
            {text: "перемена погоды"}
        ]

        onConfirmed: (text) => {
            currentRecord.setTriggers(text)
            dlg.close()
            Qt.callLater(() => page.StackView.view.pop())
        }
    }
}
