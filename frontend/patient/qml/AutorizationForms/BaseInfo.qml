import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PainAnalyzer 1.0
Item {
    id: root
    anchors.fill: parent

    signal openRequested(string key)
    signal backRequested()
    Keys.onEscapePressed: (e) => { e.accepted = true; win.goBack() }
    Keys.onBackPressed:   (e) => { e.accepted = true; win.goBack() }
    // выбранная дата
    property date selectedDate: new Date(1924, 4, 15) // 15.05.1924 (месяц 0..11)

    function pad2(n) { return (n < 10 ? "0" : "") + n }
    function formatDate(d) {
        if (!d) return ""
        return pad2(d.getDate()) + "." + pad2(d.getMonth() + 1) + "." + d.getFullYear()
    }

    Rectangle { anchors.fill: parent; color: "white" }

    Rectangle {
        id: card
        width: Math.min(520, root.width - 40)
        height: 360
        radius: 16
        color: "#E9E9EF"
        border.color: "#E2E2E8"
        border.width: 1
        anchors.centerIn: parent

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 18
            spacing: 12

            Item { Layout.fillWidth: true; Layout.preferredHeight: 4 }

            Label {
                text: "Введите данные"
                Layout.alignment: Qt.AlignHCenter
                color: "#3A3A3A"
                font.pixelSize: 16
                font.weight: Font.Medium
            }

            TextField {
                id: birthDateField
                Layout.fillWidth: true
                placeholderText: "Дата рождения"
                readOnly: true
                text: root.formatDate(root.selectedDate)
                rightPadding: 36

                ToolButton {
                    anchors.right: parent.right
                    anchors.rightMargin: 6
                    anchors.verticalCenter: parent.verticalCenter
                    width: 28; height: 28
                    background: Item {}
                    contentItem: Text {
                        text: "📅"
                        font.pixelSize: 16
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    onClicked: datePopup.open()
                }
            }

            Button {
                Layout.alignment: Qt.AlignHCenter
                text: "Выбрать дату"
                font.pixelSize: 12
                implicitHeight: 34
                implicitWidth: 140
                onClicked: datePopup.open()
            }

            TextField {
                id: weightField
                Layout.fillWidth: true
                placeholderText: "Вес (кг)"
                inputMethodHints: Qt.ImhDigitsOnly
                text: "44"
            }

            TextField {
                id: heightField
                Layout.fillWidth: true
                placeholderText: "Рост (см)"
                inputMethodHints: Qt.ImhDigitsOnly
                text: "155"
            }

            Item { Layout.fillWidth: true; Layout.fillHeight: true }
        }
    }

    // стрелки снизу
    Item {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.leftMargin: 24
        anchors.rightMargin: 24
        anchors.bottomMargin: 18
        height: 44

        ToolButton {
            width: 44; height: 44
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            background: Item {}
            contentItem: Text {
                text: "←"
                color: "#D63B3B"
                font.pixelSize: 22
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            onClicked: root.backRequested()
        }

        ToolButton {
            width: 44; height: 44
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            background: Item {}
            contentItem: Text {
                text: "→"
                color: "#D63B3B"
                font.pixelSize: 22
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            onClicked: {
                PatientManager.getPatient().setBirthday(root.selectedDate)
                PatientManager.getPatient().setHeight(heightField.text)
                PatientManager.getPatient().setWeight(weightField.text)
                root.openRequested("Record")
            }
        }
    }

    // ===== Popup календаря (MonthGrid) =====
    Popup {
        id: datePopup
        modal: true
        focus: true
        padding: 12
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
        anchors.centerIn: Overlay.overlay

        background: Rectangle {
            radius: 12
            color: "white"
            border.color: "#DADAE2"
            border.width: 1
        }

        // месяц, который сейчас показываем
        property date visibleMonth: new Date(root.selectedDate.getFullYear(),
            root.selectedDate.getMonth(), 1)

        function monthTitle(d) {
            // без Locale тоже можно, но так красивее
            return Qt.locale().standaloneMonthName(d.getMonth() + 1) + " " + d.getFullYear()
        }

        function addMonths(d, delta) {
            return new Date(d.getFullYear(), d.getMonth() + delta, 1)
        }

        contentItem: ColumnLayout {
            spacing: 10

            // шапка с навигацией
            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                ToolButton {
                    text: "‹"
                    onClicked: datePopup.visibleMonth = datePopup.addMonths(datePopup.visibleMonth, -1)
                }

                Label {
                    Layout.fillWidth: true
                    horizontalAlignment: Text.AlignHCenter
                    text: datePopup.monthTitle(datePopup.visibleMonth)
                    font.pixelSize: 14
                    color: "#333"
                }

                ToolButton {
                    text: "›"
                    onClicked: datePopup.visibleMonth = datePopup.addMonths(datePopup.visibleMonth, 1)
                }
            }

            // дни недели
            DayOfWeekRow {
                Layout.fillWidth: true
                locale: Qt.locale()
                delegate: Label {
                    text: model.shortName
                    horizontalAlignment: Text.AlignHCenter
                    color: "#666"
                    font.pixelSize: 12
                }
            }

            // сама сетка месяца
            MonthGrid {
                id: monthGrid
                Layout.preferredWidth: 320
                Layout.preferredHeight: 300

                locale: Qt.locale()
                month: datePopup.visibleMonth.getMonth() + 1  // 1..12
                year: datePopup.visibleMonth.getFullYear()

                delegate: Item {
                    required property date date
                    required property int day
                    required property int month
                    required property int year

                    readonly property bool inCurrentMonth: (month === monthGrid.month && year === monthGrid.year)
                    readonly property bool isSelected: (
                        root.selectedDate
                        && date.getFullYear() === root.selectedDate.getFullYear()
                        && date.getMonth() === root.selectedDate.getMonth()
                        && date.getDate() === root.selectedDate.getDate()
                    )

                    implicitWidth: 40
                    implicitHeight: 36

                    Rectangle {
                        anchors.centerIn: parent
                        width: 34
                        height: 34
                        radius: 17
                        color: isSelected ? "#D63B3B" : "transparent"
                    }

                    Label {
                        anchors.centerIn: parent
                        text: day
                        color: !inCurrentMonth ? "#B0B0B0" : (isSelected ? "white" : "#333")
                        font.pixelSize: 13
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            root.selectedDate = date
                            birthDateField.text = root.formatDate(date)
                            datePopup.close()
                        }
                    }
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                Button {
                    text: "Сегодня"
                    Layout.fillWidth: true
                    onClicked: {
                        const d = new Date()
                        root.selectedDate = d
                        birthDateField.text = root.formatDate(d)
                        datePopup.visibleMonth = new Date(d.getFullYear(), d.getMonth(), 1)
                        datePopup.close()
                    }
                }

                Button {
                    text: "Закрыть"
                    Layout.fillWidth: true
                    onClicked: datePopup.close()
                }
            }
        }
    }
}