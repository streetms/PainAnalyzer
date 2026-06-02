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
        parent: Overlay.overlay

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
        onConfirmed: (items) => {
            PatientManager.setTriggers(items)
            dlg.close()
            Qt.callLater(() => page.StackView.view.pop())
        }
    }
}
