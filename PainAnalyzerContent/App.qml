import QtQuick
import QtQuick.Window
import QtQuick3D

Window {
    width: 800
    height: 600
    visible: true
    title: "3D Head Model Example"

    View3D {
        anchors.fill: parent

        // 💡 Свет
        DirectionalLight {
            eulerRotation.x: -45
            eulerRotation.y: 45
            brightness: 2.0
        }

        // 🎥 Камера
        PerspectiveCamera {
            id: camera
            position: Qt.vector3d(0, 0, 600)
            eulerRotation.x: -10
        }
        // Head{
        //
        // }
        // 🧠 Модель (наш .glb файл)
        Head{
            scale: Qt.vector3d(100, 100, 100)
            eulerRotation: Qt.vector3d(-90, 0, 0)
        }
        // Model {
        //     id: headModel
        //     source: "qrc:/PainAnalyzer/models/head.glb"   // путь к твоему файлу
        //     scale: Qt.vector3d(1, 1, 1)
        //     materials: DefaultMaterial {
        //         lighting: DefaultMaterial.FragmentLighting
        //     }
        // }
    }
}
