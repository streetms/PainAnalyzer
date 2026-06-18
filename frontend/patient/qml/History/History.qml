import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Page {
    id: root
    signal backRequested()
    Keys.onEscapePressed: (e) => { e.accepted = true; win.goBack() }
    Keys.onBackPressed:   (e) => { e.accepted = true; win.goBack() }
    background: Rectangle {
        color: "#f3f4f6"
    }
    Component.onCompleted: {
        let now = new Date();
        let firstDay = new Date(now.getFullYear(), now.getMonth(), 1);
        let lastDay = new Date(now.getFullYear(), now.getMonth() + 1, 0);

        let startStr = Qt.formatDateTime(firstDay, Qt.ISODate);
        lastDay.setHours(23, 59, 59, 999);
        let endStr = Qt.formatDateTime(lastDay, Qt.ISODate);

        episodesViewModel.refresh(startStr, endStr);
    }

    // 2. ЖДЕМ, пока C++ скажет, что данные загружены и добавлены в модель
    Connections {
        target: episodesViewModel.listModel

        // Этот сигнал автоматически вызывается QAbstractListModel после вызова endResetModel() в C++
        function onModelReset() {
            loadChartDataForCurrentMonth();
        }
    }

    // 3. Сама функция теперь только рисует график
    function loadChartDataForCurrentMonth() {
        let now = new Date();
        let year = now.getFullYear();
        let month = now.getMonth() + 1; // В C++ мы ожидаем месяцы 1-12

        // Теперь данные точно пришли, берем их из модели
        let rawData = episodesViewModel.listModel.getChartData(year, month);

        let formattedPoints = [];
        for (let i = 0; i < rawData.length; i++) {
            formattedPoints.push({
                x: rawData[i].day,
                y: rawData[i].intensity
            });
            // console.log("День:", rawData[i].day, "Интенсивность:", rawData[i].intensity);
        }

        chart.points = formattedPoints;
        chart.maxX = rawData.length;
        chart.requestPaint();
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 16
        anchors.margins: 20

        Rectangle {
            id: chartContainer
            Layout.fillWidth: true
            height: 260
            radius: 20
            color: "#ffffff"
            border.width: 0

            Column {

                anchors.fill: parent
                anchors.margins: 20
                spacing: 10

                PainLevelGraph {
                    id : chart
                }
            }
        }

        Label {
            text: "Прошлые записи"
            font.pixelSize: 22
            font.bold: true
            color: "#111827"
        }

        HistoryListView{
            modelData: episodesViewModel.listModel
        }
        Button {
            text: "Скачать отчет"
            width: 170
            height: 46
            background: Rectangle { radius: 23; color: "#2E8B57" }
            contentItem: Text { text: "Скачать отчет"; color: "white"; anchors.centerIn: parent; font.pixelSize: 16; font.bold: true }

            onClicked: {
                // Фотографируем ТОЛЬКО блок с графиком (chartContainer)
                chartContainer.grabToImage(function(result) {

                    // Сохраняем картинку во временный файл
                    let tempPath = "temp_chart.png"
                    result.saveToFile(tempPath)

                    // Вызываем наш C++ метод для генерации полного документа!
                    episodesViewModel.exportFullReportToPdf(tempPath)

                    console.log("Многостраничный отчет сгенерирован!")
                })
            }
        }
        // Button {
        //     text: "Назад"
        //     Layout.alignment: Qt.AlignHCenter
        //     width: 170
        //     height: 46
        //
        //     background: Rectangle {
        //         radius: 23
        //         color: "#4a5580"
        //     }
        //
        //     contentItem: Text {
        //         text: "Назад"
        //         color: "white"
        //         anchors.centerIn: parent
        //         font.pixelSize: 16
        //         font.bold: true
        //     }
        //
        //     onClicked: root.backRequested()
        // }

    }
}