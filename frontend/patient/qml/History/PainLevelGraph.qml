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

        function getPoint(i) {
            return {
                x: getX(points[i].x),
                y: getY(points[i].y),
                v: points[i].y
            }
        }

        var first = getPoint(0)
        var last = getPoint(points.length - 1)

        /* ---------- ЗАЛИВКА ---------- */

        ctx.beginPath()
        ctx.moveTo(first.x, first.y)

        for (var i = 0; i < points.length - 1; i++) {

            var p0 = getPoint(Math.max(i - 1, 0))
            var p1 = getPoint(i)
            var p2 = getPoint(i + 1)
            var p3 = getPoint(Math.min(i + 2, points.length - 1))

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

        /* ---------- ЛИНИЯ ---------- */

        for (var i = 0; i < points.length - 1; i++) {

            var p0 = getPoint(Math.max(i - 1, 0))
            var p1 = getPoint(i)
            var p2 = getPoint(i + 1)
            var p3 = getPoint(Math.min(i + 2, points.length - 1))

            var cp1x = p1.x + (p2.x - p0.x) / 6
            var cp1y = p1.y + (p2.y - p0.y) / 6

            var cp2x = p2.x - (p3.x - p1.x) / 6
            var cp2y = p2.y - (p3.y - p1.y) / 6

            var grad = ctx.createLinearGradient(p1.x, p1.y, p2.x, p2.y)
            grad.addColorStop(0, colorForValue(p1.v))
            grad.addColorStop(1, colorForValue(p2.v))

            ctx.beginPath()
            ctx.moveTo(p1.x, p1.y)
            ctx.bezierCurveTo(cp1x, cp1y, cp2x, cp2y, p2.x, p2.y)

            ctx.lineWidth = 3
            ctx.strokeStyle = grad

            ctx.shadowColor = "rgba(0,0,0,0.08)"
            ctx.shadowBlur = 3

            ctx.stroke()
        }

        ctx.shadowBlur = 0

        /* ---------- ТОЧКИ ---------- */

        for (var i = 0; i < points.length; i++) {

            var px = getX(points[i].x)
            var py = getY(points[i].y)

            ctx.beginPath()
            ctx.arc(px, py, 3, 0, Math.PI * 2)
            ctx.fillStyle = colorForValue(points[i].y)
            ctx.fill()
        }

        /* ---------- ОСЬ ---------- */

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
            var x = getX(d)
            ctx.fillText(d, x - 5, topPad + chartH + 18)
        }
    }
}