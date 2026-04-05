import QtQuick
import QtQuick3D
import QtQuick.Shapes
import QtQuick.Controls

Page {
    Keys.onEscapePressed: (e) => { e.accepted = true; win.goBack() }
    Keys.onBackPressed:   (e) => { e.accepted = true; win.goBack() }
    title: "Head Lasso Picker (Qt 6.11)"
    property bool selectionMode: true
    Rectangle {
        anchors.fill: parent
        color: "black"

        MouseArea {
            enabled: !selectionMode
            anchors.fill: parent
            hoverEnabled: true
            acceptedButtons: Qt.LeftButton

            onPressed: (event) => {
                view3d.contour = [Qt.point(event.x, event.y)]
                view3d.updatePath()
                console.log("⏺️ Start", event.x, event.y)
            }

            onPositionChanged: (event) => {
                if (!pressed)
                    return
                view3d.contour.push(Qt.point(event.x, event.y))
                view3d.updatePath()
            }

            onReleased: (event) => {
                view3d.maybeClosePath()
                view3d.selectInsideContour()
                console.log("🟢 Released")
            }
        }
        Scene3D {
            id:view3d
            anchors.fill: parent
        }
        MultiPointTouchArea {
            enabled: selectionMode
            anchors.fill: parent
            touchPoints: [
                TouchPoint {
                    id: p1
                },
                TouchPoint {
                    id: p2
                }
            ]
            property real lastX: 0
            property real lastY: 0
            property real lastDistance: 0
            property real baseScale: view3d.head.scale.x / 100
            property bool pinching: false

            onPressed: {
                if (p1.pressed && !p2.pressed) {
                    // один палец — начинаем вращение
                    lastX = p1.x
                    lastY = p1.y
                    pinching = false
                } else if (p1.pressed && p2.pressed) {
                    // два пальца — начинаем масштабирование
                    lastDistance = Math.hypot(p1.x - p2.x, p1.y - p2.y)
                    baseScale = view3d.head.scale.x / 100
                    pinching = true
                }
            }
            onUpdated: {
                if (!pinching && p1.pressed && !p2.pressed) {
                    // вращение
                    var dx = p1.x - lastX
                    var dy = p1.y - lastY
                    lastX = p1.x
                    lastY = p1.y

                    view3d.head.eulerRotation.y += dx * 0.5
                    view3d.head.eulerRotation.x += dy * 0.5
                } else if (pinching && p1.pressed && p2.pressed) {
                    // масштабирование
                    var dist = Math.hypot(p1.x - p2.x, p1.y - p2.y)
                    var scaleFactor = dist / lastDistance
                    var s = Math.min(5, Math.max(0.3, baseScale * scaleFactor))
                    view3d.head.scale = Qt.vector3d(100 * s, 100 * s, 100 * s)
                }
            }
            onReleased: {
                pinching = false
            }
        }
        Button {
            text: selectionMode ?  "Навигация" : "Выделение"
            onClicked:{
                selectionMode = !selectionMode
                view3d.contour = []
                view3d.updatePath()
                view3d.clearSelection()
            }
        }
    }
}