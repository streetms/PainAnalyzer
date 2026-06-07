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
            id: mesh_0_008
            objectName: "Mesh_0.008"
            pickable: true
            rotation: Qt.quaternion(0.716446, -0.591223, 0.318823, 0.188451)
            source: "qrc:/PainAnalyzer/assets/meshes/mesh_0_008_mesh.mesh"
            materials: [baseGrayMaterial]
        }
        Model {
            id: mesh_0_009
            objectName: "Mesh_0.009"
            pickable: true
            rotation: Qt.quaternion(0.716446, -0.591223, 0.318823, 0.188451)
            source: "qrc:/PainAnalyzer/assets/meshes/mesh_0_009_mesh.mesh"
            materials: [baseGrayMaterial]
        }
        Model {
            id: mesh_0_010
            objectName: "Mesh_0.010"
            pickable: true
            rotation: Qt.quaternion(0.716446, -0.591223, 0.318823, 0.188451)
            source: "qrc:/PainAnalyzer/assets/meshes/mesh_0_010_mesh.mesh"
            materials: [baseGrayMaterial]
        }
        Model {
            id: mesh_0_011
            objectName: "Mesh_0.011"
            pickable: true
            rotation: Qt.quaternion(0.716446, -0.591223, 0.318823, 0.188451)
            source: "qrc:/PainAnalyzer/assets/meshes/mesh_0_011_mesh.mesh"
            materials: [baseGrayMaterial]
        }
        Model {
            id: mesh_0_012
            objectName: "Mesh_0.012"
            pickable: true
            rotation: Qt.quaternion(0.716446, -0.591223, 0.318823, 0.188451)
            source: "qrc:/PainAnalyzer/assets/meshes/mesh_0_012_mesh.mesh"
            materials: [baseGrayMaterial]
        }
        Model {
            id: mesh_0_013
            objectName: "Mesh_0.013"
            pickable: true
            rotation: Qt.quaternion(0.716446, -0.591223, 0.318823, 0.188451)
            source: "qrc:/PainAnalyzer/assets/meshes/mesh_0_013_mesh.mesh"
            materials: [baseGrayMaterial]
        }
        Model {
            id: mesh_014
            objectName: "Mesh_0.014"
            pickable: true
            rotation: Qt.quaternion(0.716446, -0.591223, 0.318823, 0.188451)
            source: "qrc:/PainAnalyzer/assets/meshes/mesh_0_014_mesh.mesh"
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
        "Mesh_0.008": yellow_material,
        "Mesh_0.010": red_material,
        "Mesh_0.011": orange_material,
        "Mesh_0.012": purple_material,
        "Mesh_0.013": blue_material,
        "Mesh_0.014": green_material
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