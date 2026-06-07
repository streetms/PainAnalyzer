import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Page {
    id: page

    // ===== ПАРАМЕТРЫ =====
    property string pageTitle: ""
    property string customPlaceholder: "Добавить"
    property var items: []              // массив строк
    signal confirmed(var selectedList)

    title: pageTitle

    // ===== МОДЕЛИ =====
    ListModel { id: commonModel }
    ListModel { id: userModel }

    Component.onCompleted: {
        for (var i = 0; i < items.length; i++) {
            commonModel.append({
                name: items[i],
                selected: false
            })
        }
    }

    function collectSelected() {
        var result = []

        for (var i = 0; i < commonModel.count; i++)
            if (commonModel.get(i).selected)
                result.push(commonModel.get(i).name)

        for (var j = 0; j < userModel.count; j++)
            if (userModel.get(j).selected)
                result.push(userModel.get(j).name)

        return result
    }

    ScrollView {
        anchors.fill: parent

        contentWidth: availableWidth
        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff


        Column {
            width: parent.width
            spacing: 16
            padding: 20

            Label {
                text: "Популярные"
                font.pixelSize: 16
            }

            Flow {
                width: parent.width
                spacing: 8

                Repeater {
                    model: commonModel

                    delegate: Chip {
                        text: name
                        selected: model.selected

                        onClicked: {
                            commonModel.setProperty(index, "selected", isSelected)
                        }
                    }
                }
            }

            Label {
                text: "Мои"
                font.pixelSize: 16
            }

            Flow {
                width: parent.width
                spacing: 8

                Repeater {
                    model: userModel

                    delegate: Chip {
                        text: name
                        selected: model.selected

                        onClicked: {
                            userModel.setProperty(index, "selected", isSelected)
                        }
                    }
                }
            }

            Row {
                spacing: 10

                TextField {
                    id: customInput
                    placeholderText: customPlaceholder
                    Layout.fillWidth: true
                }

                Button {
                    text: "Добавить"
                    onClicked: {
                        if (customInput.text.length > 0) {
                            userModel.append({
                                name: customInput.text,
                                selected: true
                            })
                            customInput.text = ""
                        }
                    }
                }
            }

            Item { height: 20 }

            Button {
                text: "Подтвердить"
                width: 180
                anchors.horizontalCenter: parent.horizontalCenter

                onClicked: {
                    confirmed(collectSelected())
                    page.StackView.view.pop()
                }
            }
        }
    }
}