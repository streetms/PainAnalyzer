import QtQuick
import QtQuick3D
import QtQuick.Shapes
import QtQuick.Controls

ApplicationWindow {
    width: 800
    height: 600
    visible: true
    title: "Rotate 3D Model"

    Rectangle {
        anchors.fill: parent
        color: "black"
        // Самый верхний слой (над View3D)
        MouseArea {
            anchors.fill: parent
            hoverEnabled: true

            onPressed: (event) => {
                view3d.contour = [Qt.point(event.x, event.y)]
                console.log("⏺️ Start", event.x, event.y)
            }

            onPositionChanged: (event) => {
                if (pressed) {
                    view3d.contour.push(Qt.point(event.x, event.y))
                    view3d.updatePath()
                }
            }

            onReleased: {
                view3d.maybeClosePath()
                console.log("🟢 Released")
            }
        }
        // --- 3D сцена ---
        View3D {
            id: view3d
            anchors.fill: parent
            camera: camera

            PerspectiveCamera {
                id: camera
                position: Qt.vector3d(0, 0, 600)
            }
            DirectionalLight { eulerRotation.x: -45; eulerRotation.y: 45 }
            // Тестовая модель головы (можно заменить на свою)
            Head {
                id: model
                position: Qt.vector3d(0, 0, 0)
                scale: Qt.vector3d(100, 100, 100)
                eulerRotation: Qt.vector3d(-90, 0, 0)
            }

            // Материал подсветки выделенных мешей
            DefaultMaterial {
                id: highlightMaterial
                diffuseColor: "orange"
            }

            // Контур в экранных координатах
            property var contour: []

            // Отрисовка линии через Shape
            Shape {
                id: drawShape
                anchors.fill: parent
                ShapePath {
                    strokeWidth: 2
                    strokeColor: "red"
                    fillColor: "transparent"
                    PathSvg { id: pathSvg }
                }
            }

            // --- Функции работы с контуром ---

            function updatePath() {
                if (contour.length < 2)
                    return
                var d = `M ${contour[0].x},${contour[0].y}`
                for (var i = 1; i < contour.length; ++i)
                    d += ` L ${contour[i].x},${contour[i].y}`
                pathSvg.path = d
            }

            function maybeClosePath() {
                if (contour.length < 3)
                    return
                const dx = contour[0].x - contour[contour.length - 1].x
                const dy = contour[0].y - contour[contour.length - 1].y
                const dist = Math.hypot(dx, dy)
                if (dist < 25) {
                    contour.push(contour[0])
                    updatePath()
                    console.log("✅ Контур замкнут, проверяем меши…")
                    selectMeshesInsideContour()
                } else {
                    console.log("❌ Контур не замкнут")
                }
            }

            function selectMeshesInsideContour() {
                // Пока просто сообщение
                console.log("Проверка попадания мешей ещё не реализована")
            }

            function worldToScreen(worldPos) {
                const projected = camera.mapFromWorldPosition(worldPos)
                return Qt.point(projected.x, projected.y)
            }
        }

        // --- Прозрачный слой для обработки касаний/мыши ---
        Rectangle {
            anchors.fill: parent
            color: "transparent"
        }
    }
}
