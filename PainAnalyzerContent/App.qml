import QtQuick
import QtQuick.Controls

ApplicationWindow {
    width: 800
    height: 600
    visible: true
    Component.onCompleted: {
        console.log("Initial item:", nav.initialItem)
        console.log("Current item:", nav.currentItem)
    }
    StackView {
        id: nav
        anchors.fill: parent
        initialItem: Screen01{}   // где ваш Repeater
    }
    property var sel
    function openScreen(key) {
        switch (key) {
            case "type":     nav.push(Qt.resolvedUrl("TypeScreen.qml")); break
            case "head":     nav.push(Qt.resolvedUrl("HeadScreen.qml")); break
            case "triggers":  nav.push(Qt.resolvedUrl("TriggerScreen.qml")); break
            case "symptoms": nav.push(Qt.resolvedUrl("SymptomsScreen.qml")); break
            case "auras":    nav.push(Qt.resolvedUrl("AurasScreen.qml")); break
            case "drugs":    nav.push(Qt.resolvedUrl("DrugsScreen.qml")); break
            default: console.log("Unknown screen key:", key)
        }
    }

    // ловим сигнал от текущего экрана (MainScreen)
    Connections {
        target: nav.currentItem
        function onOpenRequested(key) { openScreen(key) }
    }
}