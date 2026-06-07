import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PainAnalyzer 1.0

SelectableListPage {
    Keys.onEscapePressed: (e) => { e.accepted = true; win.goBack() }
    Keys.onBackPressed:   (e) => { e.accepted = true; win.goBack() }
    pageTitle: "Симптомы"
    customPlaceholder: "Новый симптом"

    items: [
        "Слезоточение на стороне боли",
        "Краснота глаза",
        "Сужение глазной щели",
        "Отек лица",
        "Выделения из носа",
        "Неприязнь к свету/звуку",
        "Тошнота/рвота"
    ]
    onConfirmed: function(list) {
        PatientManager.setSympoms(list)
    }
}