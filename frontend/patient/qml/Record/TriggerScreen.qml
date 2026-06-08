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
        "прикосновения к лицу",
        "чистка зубов",
        "Разговор",
        "Ветер",
        "Широкое открывание рта",
        "Прием пищи/жевание",
        "нарушение режима сна",
        "алкоголь",
        "менструация",
        "стресс",
        "голод",
        "перемена погоды"
    ]
    userItems: Settings.userTriggers()
    onConfirmed: function(list) {
        PatientManager.setTriggers(list)
        Settings.updateTriggers(userItems)
    }
}