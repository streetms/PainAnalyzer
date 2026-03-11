
import QtQuick
import QtQuick.Controls
import QtQuick3D

ApplicationWindow {
    width: 800
    height: 600
    visible: true
    title: "Rotate 3D Model"

    Rectangle {
        anchors.fill: parent
        color: "black"

        // == View3D со сценой ==
        View3D {
            id: view
            anchors.fill: parent

            environment: SceneEnvironment {
                clearColor: "#202020"
                backgroundMode: SceneEnvironment.Color
            }

            PerspectiveCamera {
                id: camera
                position: Qt.vector3d(0, 0, 600)
                eulerRotation.x: 0                 // смотрит прямо
                eulerRotation.y: 0
            }

            DirectionalLight { eulerRotation.x: -45; eulerRotation.y: 45 }

            Head{
                id : model
                position: Qt.vector3d(0, 0, 0)
                scale: Qt.vector3d(100, 100, 100)
                eulerRotation: Qt.vector3d(-90, 0, 0)
                }
        }
        // === вращение ===
        MultiPointTouchArea {
            anchors.fill: parent
            touchPoints: [
                TouchPoint { id: p1 },
                TouchPoint { id: p2 }
            ]

            property real lastX: 0
            property real lastY: 0
            property real lastDistance: 0
            property real baseScale: model.scale.x / 100
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
                    baseScale = model.scale.x / 100
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

                    model.eulerRotation.y += dx * 0.5
                    model.eulerRotation.x += dy * 0.5
                } else if (pinching && p1.pressed && p2.pressed) {
                    // масштабирование
                    var dist = Math.hypot(p1.x - p2.x, p1.y - p2.y)
                    var scaleFactor = dist / lastDistance
                    var s = Math.min(5, Math.max(0.3, baseScale * scaleFactor))
                    model.scale = Qt.vector3d(100 * s, 100 * s, 100 * s)
                }
            }

            onReleased: {
                pinching = false
            }
        }
    }
}
