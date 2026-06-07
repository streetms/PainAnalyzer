import QtQuick 6.11
import QtQuick.Controls 6.11
import QtQuick.Controls.Material 6.11
import Shared 1.0
import PainAnalyzer 1.0
import "../Menu"

ApplicationWindow {
    width: 800
    height: 600
    visible: true
    id: win
    Snackbar {
        id: snackbar
    }

    Component.onCompleted: {
        console.log("stack:", stack)
        console.log("Initial item:", stack.initialItem ? stack.initialItem : "null")
        console.log("Current item:", stack.currentItem ? stack.currentItem : "null")
    }

    StackView {
        id: stack
        anchors.fill: parent
        initialItem:
            MainMenu{}
    }

    function goBack() {
        if (stack.depth > 1) {
            stack.pop()
        }
    }

    property var sel

    function openScreen(key) {
        switch (key) {
            case "Menu": {
                stack.push(Qt.resolvedUrl("../Menu/MainMenu.qml"));
                break
            }
            case "Record": {
                stack.push(Qt.resolvedUrl("../Record/Record.qml"));
                break
            }
            case "History":{
                stack.push(Qt.resolvedUrl("../History/History.qml"));
                break
            }
            case "type":
                stack.push(Qt.resolvedUrl("../Record/PainTypeScreen.qml"));
                break
            case "head":
                stack.push(Qt.resolvedUrl("../Record/HeadScreen.qml"));
                break
            case "triggers":
                stack.push(Qt.resolvedUrl("../Record/TriggerScreen.qml"));
                break
            case "symptoms":
                stack.push(Qt.resolvedUrl("../Record/SymptomsScreen.qml"));
                break
            case "auras":
                stack.push(Qt.resolvedUrl("../Record/AurasScreen.qml"));
                break
            case "drugs":
                stack.push(Qt.resolvedUrl("../Record/DrugScreen.qml"));
                break
            // case "BaseInfo": {
            //     stack.push(Qt.resolvedUrl("AutorizationForms/BaseInfo.qml"));
            //     break
            // }
            // case "FIO": {
            //     stack.push(Qt.resolvedUrl("AutorizationForms/FIO.qml"));
            //     break
            // }
            // case "Email": {
            //     stack.push(Qt.resolvedUrl("AutorizationForms/Email.qml"));
            //     break
            // }
            default:
                console.log("Unknown screen key:", key)
        }
    }

    // ловим сигнал от текущего экрана (MainScreen)
    Connections {
        target: stack.currentItem

        function onOpenRequested(key) {
            openScreen(key)
        }

        function onBackRequested() {
            console.log("clicked")
            goBack()
        }
        // function onAddEntryClicked(){
        //     stack.push("AutorizationForms/FIO.qml")
        // }
    }
    Connections {
        target: PatientManager
        function onErrorOccurred(message) {
            snackbar.show(message)
        }
    }
}