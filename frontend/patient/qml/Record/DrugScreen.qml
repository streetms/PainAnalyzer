import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PainAnalyzer 1.0
SelectableListPage {
    Keys.onEscapePressed: (e) => { e.accepted = true; win.goBack() }
    Keys.onBackPressed:   (e) => { e.accepted = true; win.goBack() }
    pageTitle: "Триггеры"
    customPlaceholder: "Новый триггер"

    items: [
            "НПВС",
            "антидепрессанты",
            "противоэпилептические",
            "транквилизаторы",
            "сосудистые"
    ]

    onConfirmed: function(list) {
        PatientManager.setDrugs(list)
    }
}