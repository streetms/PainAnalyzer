import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Page {
    id: root
    signal backRequested()

    background: Rectangle {
        color: "#f3f4f6"
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 16
        anchors.margins: 20

        Rectangle {
            Layout.fillWidth: true
            height: 260
            radius: 20
            color: "#ffffff"
            border.width: 0

            Column {
                anchors.fill: parent
                anchors.margins: 20
                spacing: 10

                Canvas {
                    id: chart
                    width: parent.width
                    height: 170

                    property var points: [
                        {x:6,y:7},
                        {x:7,y:8},
                        {x:8,y:9},
                        {x:9,y:10},
                        {x:10,y:8},
                        {x:11,y:9},
                        {x:12,y:6},
                        {x:13,y:3},
                        {x:14,y:5},
                        {x:15,y:6}
                    ]

                    function colorForValue(v){
                        if(v <= 4) return "#6cc070"
                        if(v <= 7) return "#f6b21a"
                        return "#ef4444"
                    }

                    onPaint: {

                        var ctx = getContext("2d")
                        ctx.clearRect(0,0,width,height)

                        var leftPad = 40
                        var bottomPad = 30
                        var topPad = 10
                        var rightPad = 10

                        var chartW = width-leftPad-rightPad
                        var chartH = height-topPad-bottomPad

                        var minX = 1
                        var maxX = 31
                        var maxY = 10

                        function getX(day){
                            return leftPad + (day-minX)/(maxX-minX)*chartW
                        }

                        function getY(val){
                            return topPad + chartH - (val/maxY)*chartH
                        }

                        function getPoint(i){
                            return {
                                x: getX(points[i].x),
                                y: getY(points[i].y),
                                v: points[i].y
                            }
                        }

                        var first = getPoint(0)
                        var last = getPoint(points.length-1)

                        /* ---------- ЗАЛИВКА ---------- */

                        ctx.beginPath()
                        ctx.moveTo(first.x,first.y)

                        for (var i = 0; i < points.length - 1; i++) {

                            var p0 = getPoint(Math.max(i-1,0))
                            var p1 = getPoint(i)
                            var p2 = getPoint(i+1)
                            var p3 = getPoint(Math.min(i+2,points.length-1))

                            var cp1x = p1.x + (p2.x - p0.x)/6
                            var cp1y = p1.y + (p2.y - p0.y)/6

                            var cp2x = p2.x - (p3.x - p1.x)/6
                            var cp2y = p2.y - (p3.y - p1.y)/6

                            ctx.bezierCurveTo(cp1x,cp1y,cp2x,cp2y,p2.x,p2.y)
                        }

                        ctx.lineTo(last.x, topPad+chartH)
                        ctx.lineTo(first.x, topPad+chartH)
                        ctx.closePath()

                        var gradFill = ctx.createLinearGradient(0,topPad,0,topPad+chartH)
                        gradFill.addColorStop(0,"rgba(255,180,120,0.55)")
                        gradFill.addColorStop(0.5,"rgba(220,220,140,0.40)")
                        gradFill.addColorStop(1,"rgba(150,220,150,0.25)")

                        ctx.fillStyle = gradFill
                        ctx.fill()

                        /* ---------- ЛИНИЯ ---------- */

                        for (var i = 0; i < points.length - 1; i++) {

                            var p0 = getPoint(Math.max(i-1,0))
                            var p1 = getPoint(i)
                            var p2 = getPoint(i+1)
                            var p3 = getPoint(Math.min(i+2,points.length-1))

                            var cp1x = p1.x + (p2.x - p0.x)/6
                            var cp1y = p1.y + (p2.y - p0.y)/6

                            var cp2x = p2.x - (p3.x - p1.x)/6
                            var cp2y = p2.y - (p3.y - p1.y)/6

                            var grad = ctx.createLinearGradient(p1.x,p1.y,p2.x,p2.y)
                            grad.addColorStop(0,colorForValue(p1.v))
                            grad.addColorStop(1,colorForValue(p2.v))

                            ctx.beginPath()
                            ctx.moveTo(p1.x,p1.y)
                            ctx.bezierCurveTo(cp1x,cp1y,cp2x,cp2y,p2.x,p2.y)

                            ctx.lineWidth = 3
                            ctx.strokeStyle = grad

                            ctx.shadowColor = "rgba(0,0,0,0.08)"
                            ctx.shadowBlur = 3

                            ctx.stroke()
                        }

                        ctx.shadowBlur = 0

                        /* ---------- ТОЧКИ ---------- */

                        for(var i=0;i<points.length;i++){

                            var px = getX(points[i].x)
                            var py = getY(points[i].y)

                            ctx.beginPath()
                            ctx.arc(px,py,3,0,Math.PI*2)
                            ctx.fillStyle = colorForValue(points[i].y)
                            ctx.fill()
                        }

                        /* ---------- ОСЬ ---------- */

                        ctx.strokeStyle="#d1d5db"
                        ctx.lineWidth=2
                        ctx.beginPath()
                        ctx.moveTo(leftPad,topPad+chartH)
                        ctx.lineTo(width-rightPad,topPad+chartH)
                        ctx.stroke()

                        ctx.fillStyle="#6b7280"
                        ctx.font="11px sans-serif"

                        for(var y=0;y<=10;y+=2){
                            ctx.fillText(y,8,getY(y)+4)
                        }

                        for(var d=1; d<=31; d+=2){
                            var x=getX(d)
                            ctx.fillText(d,x-5,topPad+chartH+18)
                        }
                    }
                }
            }
        }

        Label {
            text: "Прошлые записи"
            font.pixelSize: 22
            font.bold: true
            color: "#111827"
        }

        ListView {
            id: historyList
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 12
            clip: true
            model: historyModel

            delegate: Rectangle {
                width: historyList.width
                radius: 16
                color: "#ffffff"
                border.width: 0

                implicitHeight: contentColumn.implicitHeight + 32

                Column {
                    id: contentColumn
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.margins: 16
                    spacing: 8

                    Text {
                        text: date
                        font.bold: true
                        font.pixelSize: 16
                        color: "#111827"
                    }

                    Text {
                        text: "Уровень боли"
                        color: "#6b7280"
                        font.pixelSize: 13
                    }

                    Text {
                        text: pain + " / 10"
                        font.bold: true
                        font.pixelSize: 18
                        color: "#111827"
                    }

                    Item {
                        width: 200
                        height: 26

                        Slider {
                            id: painSlider
                            anchors.fill: parent
                            from: 0
                            to: 10
                            value: pain
                            enabled: false

                            background: Rectangle {
                                x: 0
                                y: parent.height/2 - 4
                                width: parent.width
                                height: 8
                                radius: 4

                                gradient: Gradient {
                                    orientation: Gradient.Horizontal
                                    GradientStop { position: 0.0; color: "#22c55e" }
                                    GradientStop { position: 0.5; color: "#eab308" }
                                    GradientStop { position: 1.0; color: "#ef4444" }
                                }
                            }

                            handle: Rectangle {
                                width: 16
                                height: 16
                                radius: 8
                                y: parent.height/2 - height/2
                                x: painSlider.visualPosition * (painSlider.availableWidth - width)

                                color: "#ef4444"
                                border.color: "white"
                                border.width: 2
                            }
                        }
                    }

                    Text {
                        text: "Симптомы"
                        color: "#6b7280"
                        font.pixelSize: 13
                    }

                    Flow {
                        width: parent.width
                        spacing: 6

                        Repeater {
                            model: symptoms.split(",")

                            delegate: Rectangle {
                                radius: 12
                                height: 26
                                color: "#f3f4f6"

                                Text {
                                    id: symptomText
                                    text: modelData.trim()
                                    anchors.centerIn: parent
                                    font.pixelSize: 12
                                    color: "#374151"
                                }

                                width: symptomText.paintedWidth + 20
                            }
                        }
                    }

                    Text {
                        text: "Триггеры"
                        color: "#6b7280"
                        font.pixelSize: 13
                    }

                    Flow {
                        width: parent.width
                        spacing: 6

                        Repeater {
                            model: triggers.split(",")

                            delegate: Rectangle {
                                radius: 12
                                height: 26
                                color: "#f3f4f6"

                                Text {
                                    id: triggerText
                                    text: modelData.trim()
                                    anchors.centerIn: parent
                                    font.pixelSize: 12
                                    color: "#374151"
                                }

                                width: triggerText.paintedWidth + 20
                            }
                        }
                    }
                }
            }
        }

        Button {
            text: "Назад"
            Layout.alignment: Qt.AlignHCenter
            width: 170
            height: 46

            background: Rectangle {
                radius: 23
                color: "#4a5580"
            }

            contentItem: Text {
                text: "Назад"
                color: "white"
                anchors.centerIn: parent
                font.pixelSize: 16
                font.bold: true
            }

            onClicked: root.backRequested()
        }
    }

    ListModel {
        id: historyModel

        ListElement {
            date: "Сегодня, 14 апреля"
            pain: 5
            symptoms: "Головная боль, Усталость, Тошнота"
            triggers: "Стресс, Мало сна"
        }

        ListElement {
            date: "Вчера, 13 апреля"
            pain: 3
            symptoms: "Тошнота, Светобоязнь"
            triggers: "Яркий свет"
        }

        ListElement {
            date: "12 апреля"
            pain: 6
            symptoms: "Головная боль, Напряжение"
            triggers: "Работа за компьютером, Пропуск еды"
        }

        ListElement {
            date: "11 апреля"
            pain: 4
            symptoms: "Усталость, Сонливость"
            triggers: "Недостаток воды"
        }

        ListElement {
            date: "10 апреля"
            pain: 2
            symptoms: "Легкая головная боль"
            triggers: "Долгая дорога"
        }

        ListElement {
            date: "9 апреля"
            pain: 7
            symptoms: "Головная боль, Тошнота"
            triggers: "Стресс"
        }
    }
}