import QtQuick
import QtQuick3D
import QtQuick.Shapes
import QtQuick.Controls

ApplicationWindow {
    width: 800
    height: 600
    visible: true
    title: "Head Lasso Picker (Qt 6.11)"
    property bool selectionMode: true
    Rectangle {
        anchors.fill: parent
        color: "black"


        // property bool lassoDrawing: false
        // // Рисуем контур пальцем
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

        View3D {
            id: view3d
            anchors.fill: parent
            camera: camera

            PerspectiveCamera {
                id: camera
                position: Qt.vector3d(0, 0, 600)
                clipFar: 5000
            }

            DirectionalLight {
                eulerRotation.x: -45; eulerRotation.y: 45
            }

            Head {
                id: head
                position: Qt.vector3d(0, 0, 0)
                scale: Qt.vector3d(100, 100, 100)
                eulerRotation: Qt.vector3d(-90, 0, 0)
            }
            // Подсветка
            PrincipledMaterial {
                id: highlightMaterial
                baseColor: "orange"
                roughness: 0.25
                metalness: 0.0
                emissiveFactor: Qt.vector3d(0.6, 0.35, 0.0)
                cullMode: PrincipledMaterial.NoCulling
                alphaMode: PrincipledMaterial.Opaque
            }

            // Контур
            property var contour: []

            // Выбор
            property var originalMaterialsByName: ({})
            property var selectedByName: ({})
            property var selectedOrder: []

            // Диагностика picking
            property bool debugPick: true

            // Линия контура
            Shape {
                anchors.fill: parent
                z: 10
                ShapePath {
                    strokeWidth: 2
                    strokeColor: "red"
                    fillColor: "transparent"
                    capStyle: ShapePath.RoundCap
                    joinStyle: ShapePath.RoundJoin
                    PathSvg {
                        id: pathSvg
                    }
                }
            }

            // Включаем pickers на мешах (важно!)
            Component.onCompleted: {
                Qt.callLater(() => {
                    console.log("meshes in app:", head.meshesList ? head.meshesList.length : "null")
                })
            }


            // --- Геометрия: point-in-polygon ---
            function isPointInPolygon(point, polygon) {
                let inside = false
                for (let i = 0, j = polygon.length - 1; i < polygon.length; j = i++) {
                    const xi = polygon[i].x, yi = polygon[i].y
                    const xj = polygon[j].x, yj = polygon[j].y
                    const intersect = ((yi > point.y) !== (yj > point.y)) &&
                        (point.x < (xj - xi) * (point.y - yi) / (yj - yi + 1e-9) + xi)
                    if (intersect) inside = !inside
                }
                return inside
            }

            function contourBounds(poly) {
                let left = 1e9, top = 1e9, right = -1e9, bottom = -1e9
                for (let i = 0; i < poly.length; ++i) {
                    const p = poly[i]
                    left = Math.min(left, p.x)
                    right = Math.max(right, p.x)
                    top = Math.min(top, p.y)
                    bottom = Math.max(bottom, p.y)
                }
                return {left, top, right, bottom}
            }

            // --- Контур: отрисовка ---
            function updatePath() {
                if (!contour || contour.length < 2) {
                    pathSvg.path = ""
                    return
                }
                let d = `M ${contour[0].x},${contour[0].y}`
                for (let i = 1; i < contour.length; ++i)
                    d += ` L ${contour[i].x},${contour[i].y}`
                pathSvg.path = d
            }

            function maybeClosePath() {
                if (!contour || contour.length < 3)
                    return
                let d = `M ${contour[0].x},${contour[0].y}`
                for (let i = 1; i < contour.length; ++i)
                    d += ` L ${contour[i].x},${contour[i].y}`
                d += " Z"
                pathSvg.path = d
            }

            // --- Выбор/подсветка ---
            function selectMesh(mesh) {
                if (!mesh || !mesh.objectName) return
                const k = mesh.objectName
                if (selectedByName[k]) return
                selectedByName[k] = true
                selectedOrder.push(k)

                head.setMeshHighlighted(k, true)
            }

            function clearSelection() {
                selectedByName = ({})
                selectedOrder = []
                head.clearHighlights()
                console.log("🧹 selection cleared")
            }

            // --- Pick по координатам ---
            function pickMeshAt(x, y) {
                // ВНИМАНИЕ: координаты должны быть в системе View3D.
                // У нас MouseArea во внешнем Rectangle с теми же anchors.fill, так что x/y совпадают.
                const r = view3d.pick(x, y)

                if (debugPick) {
                    if (!r)
                        console.log("pick: null at", x, y)
                    else
                        console.log("pick:", (r.objectHit ? r.objectHit.objectName : "no objectHit"),
                            " at", x, y)
                }

                if (!r || !r.objectHit)
                    return null

                return r.objectHit
            }

            // --- Lasso selection ---
            function selectInsideContour() {
                if (!contour || contour.length < 3) {
                    console.log("⚠️ contour too short")
                    return
                }

                const b = contourBounds(contour)
                const step = 10

                // сбросим прошлый выбор (если нужно)
                clearSelection()

                let hits = 0
                for (let y = b.top; y <= b.bottom; y += step) {
                    for (let x = b.left; x <= b.right; x += step) {
                        const p = Qt.point(x, y)
                        if (!isPointInPolygon(p, contour))
                            continue

                        const mesh = pickMeshAt(x, y)
                        if (mesh) {
                            hits++
                            selectMesh(mesh)
                        }
                    }
                }

                console.log("🎯 hits:", hits, " Selected parts:", selectedOrder.join(", "))
            }

            // UI
            Rectangle {
                z: 20
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.margins: 12
                radius: 8
                color: "#66000000"
                border.color: "#44ffffff"
                border.width: 1
            }
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
            property real baseScale: head.scale.x / 100
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
                    baseScale = head.scale.x / 100
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

                    head.eulerRotation.y += dx * 0.5
                    head.eulerRotation.x += dy * 0.5
                } else if (pinching && p1.pressed && p2.pressed) {
                    // масштабирование
                    var dist = Math.hypot(p1.x - p2.x, p1.y - p2.y)
                    var scaleFactor = dist / lastDistance
                    var s = Math.min(5, Math.max(0.3, baseScale * scaleFactor))
                    head.scale = Qt.vector3d(100 * s, 100 * s, 100 * s)
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
            }
        }
    }
}