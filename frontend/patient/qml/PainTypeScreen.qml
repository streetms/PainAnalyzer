import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PainAnalyzer 1.0

SelectableListPage {
    Keys.onEscapePressed: (e) => { e.accepted = true; win.goBack() }
    Keys.onBackPressed:   (e) => { e.accepted = true; win.goBack() }
    pageTitle: "Ауры"
    customPlaceholder: "Новая аура"

    items: [
            "пульсирует",
            "распирает",
            "сжимает",
            "ноет",
            "простреливает",
            "жжет",
            "колет иглами",
    ]
    onConfirmed: function(list) {
        PatientManager.setPainTypes(list)
    }
}
