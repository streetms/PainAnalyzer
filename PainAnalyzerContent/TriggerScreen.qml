import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
Page {
    id: page
    SelectionDialog {
        id: dlg
        parent: page.Window.overlay
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
            close()
        }
    }

}