import QtQuick
import QtQuick3D

Node {

    id: root

    // --- БАЗОВЫЙ серый материал (по умолчанию на всей голове) ---

    // --- Цветные материалы (для выделения) ---

    Node {
        id: node_1
        objectName: "Node_1"

        Model {
            id: mesh_0
            objectName: "Mesh_0"
            pickable: true
            rotation: Qt.quaternion(0.716446, -0.591223, 0.318823, 0.188451)
            source: "qrc:/PainAnalyzer/assets/meshes/mesh_0_001_mesh.mesh"
            // изначально серый
            materials: [baseGrayMaterial]
        }
        Model {
            id: mesh_0_001
            objectName: "Mesh_0.001"
            pickable: true
            rotation: Qt.quaternion(0.716446, -0.591223, 0.318823, 0.188451)
            source: "qrc:/PainAnalyzer/assets/meshes/mesh_0_002_mesh.mesh"
            materials: [baseGrayMaterial]
        }
        Model {
            id: mesh_0_002
            objectName: "Mesh_0.002"
            pickable: true
            rotation: Qt.quaternion(0.716446, -0.591223, 0.318823, 0.188451)
            source: "qrc:/PainAnalyzer/assets/meshes/mesh_0_003_mesh.mesh"
            materials: [baseGrayMaterial]
        }
        Model {
            id: mesh_0_003
            objectName: "Mesh_0.003"
            pickable: true
            rotation: Qt.quaternion(0.716446, -0.591223, 0.318823, 0.188451)
            source: "qrc:/PainAnalyzer/assets/meshes/mesh_0_004_mesh.mesh"
            materials: [baseGrayMaterial]
        }
        Model {
            id: mesh_0_004
            objectName: "Mesh_0.004"
            pickable: true
            rotation: Qt.quaternion(0.716446, -0.591223, 0.318823, 0.188451)
            source: "qrc:/PainAnalyzer/assets/meshes/mesh_0_005_mesh.mesh"
            materials: [baseGrayMaterial]
        }
        Model {
            id: mesh_0_005
            objectName: "Mesh_0.005"
            pickable: true
            rotation: Qt.quaternion(0.716446, -0.591223, 0.318823, 0.188451)
            source: "qrc:/PainAnalyzer/assets/meshes/mesh_0_006_mesh.mesh"
            materials: [baseGrayMaterial]
        }
        Model {
            id: mesh_0_006
            objectName: "Mesh_0.006"
            pickable: true
            rotation: Qt.quaternion(0.716446, -0.591223, 0.318823, 0.188451)
            source: "qrc:/PainAnalyzer/assets/meshes/mesh_0_007_mesh.mesh"
            materials: [baseGrayMaterial]
        }
    }

    Node {
        id: __materialLibrary__

        PrincipledMaterial {
            id: baseGrayMaterial
            objectName: "baseGray"
            baseColor: "#808080"
            roughness: 0.65
            metalness: 0.0
            cullMode: PrincipledMaterial.NoCulling
            alphaMode: PrincipledMaterial.Opaque
        }

        PrincipledMaterial {
            id: yellow_material
            objectName: "yellow"
            baseColor: "#ffcccb02"
            roughness: 0.5
            metalness: 0.0
            cullMode: PrincipledMaterial.NoCulling
            alphaMode: PrincipledMaterial.Opaque
        }

        PrincipledMaterial {
            id: orange_material
            objectName: "orange"
            baseColor: "#ffcc5901"
            roughness: 0.5
            metalness: 0.0
            cullMode: PrincipledMaterial.NoCulling
            alphaMode: PrincipledMaterial.Opaque
        }

        PrincipledMaterial {
            id: purple_material
            objectName: "purple"
            baseColor: "#ffcc004c"
            roughness: 0.5
            metalness: 0.0
            cullMode: PrincipledMaterial.NoCulling
            alphaMode: PrincipledMaterial.Opaque
        }

        PrincipledMaterial {
            id: principledMaterial
            objectName: "metal"
            metalness: 1
            roughness: 1
            alphaMode: PrincipledMaterial.Opaque
            cullMode: PrincipledMaterial.NoCulling
        }

        PrincipledMaterial {
            id: green_material
            objectName: "green"
            baseColor: "#ff03cc00"
            roughness: 0.5
            metalness: 0.0
            cullMode: PrincipledMaterial.NoCulling
            alphaMode: PrincipledMaterial.Opaque
        }

        PrincipledMaterial {
            id: blue_material
            objectName: "blue"
            baseColor: "#ff0171cc"
            roughness: 0.5
            metalness: 0.0
            cullMode: PrincipledMaterial.NoCulling
            alphaMode: PrincipledMaterial.Opaque
        }

        PrincipledMaterial {
            id: red_material
            objectName: "red"
            baseColor: "#ffcc0002"
            roughness: 0.5
            metalness: 0.0
            cullMode: PrincipledMaterial.NoCulling
            alphaMode: PrincipledMaterial.Opaque
        }
    }

    // Список мешей
    property var meshesList: []

    // Карта: meshName -> материал "цвета выделения"
    property var highlightMaterialByMeshName: ({
                                                   "Mesh_0": yellow_material,
                                                   "Mesh_0.001": orange_material,
                                                   "Mesh_0.002": purple_material,
                                                   "Mesh_0.003": principledMaterial,
                                                   "Mesh_0.004": green_material,
                                                   "Mesh_0.005": blue_material,
                                                   "Mesh_0.006": red_material
                                               })

    function meshByName(name) {
        if (!meshesList) return null
        for (let i = 0; i < meshesList.length; ++i) {
            if (meshesList[i].objectName === name)
                return meshesList[i]
        }
        return null
    }

    // Включить/выключить подсветку конкретного меша
    function setMeshHighlighted(meshName, on) {
        const mesh = meshByName(meshName)
        if (!mesh) return

        if (on) {
            const mat = highlightMaterialByMeshName[meshName]
            if (mat !== undefined)
                mesh.materials = [mat]
        } else {
            mesh.materials = [baseGrayMaterial]
        }
    }

    function clearHighlights() {
        if (!meshesList) return
        for (let i = 0; i < meshesList.length; ++i)
            meshesList[i].materials = [baseGrayMaterial]
    }

    Component.onCompleted: {
        meshesList = node_1.children.filter(c => c instanceof Model)
        // На всякий случай принудительно всё в серый при старте:
        clearHighlights()
        console.log("✅ meshesList:", meshesList.map(m => m.objectName))
    }
}

