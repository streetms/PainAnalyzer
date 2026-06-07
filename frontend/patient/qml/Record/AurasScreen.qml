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
        "зрительная",
        "слабость в конечностях с одной стороны",
        "потеря зрения на один глаз",
        "трудности при произношении слов",
        "двоение в глазах",
        "шаткость"
    ]
    onConfirmed: function(list) {
        PatientManager.setAuras(list)
    }
}
