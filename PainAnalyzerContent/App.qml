import QtQuick
import QtQuick.Controls
import "AutorizationForms"
ApplicationWindow {
    width: 800
    height: 600
    visible: true
    id: win
    Component.onCompleted: {
        console.log("stack:", stack)
        console.log("Initial item:", stack.initialItem ? stack.initialItem : "null")
        console.log("Current item:", stack.currentItem ? stack.currentItem : "null")
    }

    StackView {
        id: stack
        anchors.fill: parent
        //initialItem: Screen01{}
        initialItem: Phone {
        }
    }

    function goBack() {
        if (stack.depth > 1) {
            stack.pop()
        }
    }

    property var sel

    function openScreen(key) {
        switch (key) {
            case "type":
                stack.push(Qt.resolvedUrl("TypeScreen.qml"));
                break
            case "head":
                stack.push(Qt.resolvedUrl("HeadScreen.qml"));
                break
            case "triggers":
                stack.push(Qt.resolvedUrl("TriggerScreen.qml"));
                break
            case "symptoms":
                stack.push(Qt.resolvedUrl("SymptomsScreen.qml"));
                break
            case "auras":
                stack.push(Qt.resolvedUrl("AurasScreen.qml"));
                break
            case "drugs":
                stack.push(Qt.resolvedUrl("DrugsScreen.qml"));
                break
            case "BaseInfo": {
                stack.push(Qt.resolvedUrl("AutorizationForms/BaseInfo.qml"));
                break
            }
            case "FIO": {
                stack.push(Qt.resolvedUrl("AutorizationForms/FIO.qml"));
                break
            }
            case "Phone": {
                stack.push(Qt.resolvedUrl("AutorizationForms/Phone.qml"));
                break
            }
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
        function onBackRequested(){
            console.log("clicked")
            goBack()
        }
    }
}