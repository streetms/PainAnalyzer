import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Canvas {
    id: chart
    width: parent.width
    height: 170

    property var points: []
    property var minX: 1
    property var maxX: 31
    property var maxY: 10

    function colorForValue(v) {
        if (v <= 4) return "#6cc070"
        if (v <= 7) return "#f6b21a"
        return "#ef4444"
    }

    onPaint: {
        var ctx = getContext("2d")
        ctx.clearRect(0, 0, width, height)

        var leftPad = 40
        var bottomPad = 30
        var topPad = 10
        var rightPad = 10

        var chartW = width - leftPad - rightPad
        var chartH = height - topPad - bottomPad

        function getX(day) {
            return leftPad + (day - minX) / (maxX - minX) * chartW
        }

        function getY(val) {
            return topPad + chartH - (val / maxY) * chartH
        }

        // 1. СНАЧАЛА ВСЕГДА РИСУЕМ ОСИ (даже если данных нет)
        ctx.strokeStyle = "#d1d5db"
        ctx.lineWidth = 2
        ctx.beginPath()
        ctx.moveTo(leftPad, topPad + chartH)
        ctx.lineTo(width - rightPad, topPad + chartH)
        ctx.stroke()

        ctx.fillStyle = "#6b7280"
        ctx.font = "11px sans-serif"

        for (var y = 0; y <= 10; y += 2) {
            ctx.fillText(y, 8, getY(y) + 4)
        }

        for (var d = 1; d <= maxX; d += 2) {
            var dx = getX(d)
            ctx.fillText(d, dx - 5, topPad + chartH + 18)
        }

        // 2. ОТБИРАЕМ ТОЛЬКО ТОЧКИ С ЗАПИСЯМИ (ИГНОРИРУЕМ 0)
        var validPoints = []
        for (var k = 0; k < points.length; k++) {
            if (points[k].y > 0) { // Добавляем только если боль > 0
                validPoints.push(points[k])
            }
        }

        // Если нет ни одной записи, прерываем рисование (оси уже нарисованы)
        if (validPoints.length === 0) return;

        function getPoint(i) {
            return {
                x: getX(validPoints[i].x),
                y: getY(validPoints[i].y),
                v: validPoints[i].y
            }
        }

        // Если запись всего одна, рисуем только кружочек (линию строить не с чем)
        if (validPoints.length === 1) {
            var singlePt = getPoint(0)
            ctx.beginPath()
            ctx.arc(singlePt.x, singlePt.y, 3, 0, Math.PI * 2)
            ctx.fillStyle = colorForValue(singlePt.v)
            ctx.fill()
            return
        }

        // 3. РИСУЕМ ЗАЛИВКУ (только по validPoints)
        var first = getPoint(0)
        var last = getPoint(validPoints.length - 1)

        ctx.beginPath()
        ctx.moveTo(first.x, first.y)

        for (var i = 0; i < validPoints.length - 1; i++) {
            var p0 = getPoint(Math.max(i - 1, 0))
            var p1 = getPoint(i)
            var p2 = getPoint(i + 1)
            var p3 = getPoint(Math.min(i + 2, validPoints.length - 1))

            var cp1x = p1.x + (p2.x - p0.x) / 6
            var cp1y = p1.y + (p2.y - p0.y) / 6

            var cp2x = p2.x - (p3.x - p1.x) / 6
            var cp2y = p2.y - (p3.y - p1.y) / 6

            ctx.bezierCurveTo(cp1x, cp1y, cp2x, cp2y, p2.x, p2.y)
        }

        ctx.lineTo(last.x, topPad + chartH)
        ctx.lineTo(first.x, topPad + chartH)
        ctx.closePath()

        var gradFill = ctx.createLinearGradient(0, topPad, 0, topPad + chartH)
        gradFill.addColorStop(0, "rgba(255,180,120,0.55)")
        gradFill.addColorStop(0.5, "rgba(220,220,140,0.40)")
        gradFill.addColorStop(1, "rgba(150,220,150,0.25)")

        ctx.fillStyle = gradFill
        ctx.fill()

        // 4. РИСУЕМ ЛИНИЮ ГРАДИЕНТА (только по validPoints)
        for (var j = 0; j < validPoints.length - 1; j++) {
            var lp0 = getPoint(Math.max(j - 1, 0))
            var lp1 = getPoint(j)
            var lp2 = getPoint(j + 1)
            var lp3 = getPoint(Math.min(j + 2, validPoints.length - 1))

            var lcp1x = lp1.x + (lp2.x - lp0.x) / 6
            var lcp1y = lp1.y + (lp2.y - lp0.y) / 6

            var lcp2x = lp2.x - (lp3.x - lp1.x) / 6
            var lcp2y = lp2.y - (lp3.y - lp1.y) / 6

            var grad = ctx.createLinearGradient(lp1.x, lp1.y, lp2.x, lp2.y)
            grad.addColorStop(0, colorForValue(lp1.v))
            grad.addColorStop(1, colorForValue(lp2.v))

            ctx.beginPath()
            ctx.moveTo(lp1.x, lp1.y)
            ctx.bezierCurveTo(lcp1x, lcp1y, lcp2x, lcp2y, lp2.x, lp2.y)

            ctx.lineWidth = 3
            ctx.strokeStyle = grad
            ctx.shadowColor = "rgba(0,0,0,0.08)"
            ctx.shadowBlur = 3
            ctx.stroke()
        }

        ctx.shadowBlur = 0

        for (var n = 0; n < validPoints.length; n++) {
            var px = getX(validPoints[n].x)
            var py = getY(validPoints[n].y)

            ctx.beginPath()
            ctx.arc(px, py, 3, 0, Math.PI * 2)
            ctx.fillStyle = colorForValue(validPoints[n].y)
            ctx.fill()
        }
    }
}