import QtQuick
import QtQuick3D

Node {
    id: node

    // Resources
    PrincipledMaterial {
        id: yellow_material
        objectName: "yellow"
        baseColor: "#ffcccb02"
        roughness: 0.5
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: orange_material
        objectName: "orange"
        baseColor: "#ffcc5901"
        roughness: 0.5
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: purple_material
        objectName: "purple"
        baseColor: "#ffcc004c"
        roughness: 0.5
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: principledMaterial
        metalness: 1
        roughness: 1
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: green_material
        objectName: "green"
        baseColor: "#ff03cc00"
        roughness: 0.5
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque

    }
    PrincipledMaterial {
        id: blue_material
        objectName: "blue"
        baseColor: "#ff0171cc"
        roughness: 0.5
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: red_material
        objectName: "red"
        baseColor: "#ffcc0002"
        roughness: 0.5
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }

    // Nodes:
    Node {
        id: node_1
        objectName: "Node_1"
        Model {
            id: mesh_0
            objectName: "Mesh_0"
            rotation: Qt.quaternion(0.716446, -0.591223, 0.318823, 0.188451)
            scale: Qt.vector3d(1, 1, 1)
            source: "qrc:/PainAnalyzer/models/meshes/mesh_0_001_mesh.mesh"
            materials: [
                yellow_material
            ]
        }
        Model {
            id: mesh_0_001
            objectName: "Mesh_0.001"
            rotation: Qt.quaternion(0.716446, -0.591223, 0.318823, 0.188451)
            scale: Qt.vector3d(1, 1, 1)
            source: "qrc:/PainAnalyzer/models/meshes/mesh_0_002_mesh.mesh"
            materials: [
                orange_material
            ]
        }
        Model {
            id: mesh_0_002
            objectName: "Mesh_0.002"
            rotation: Qt.quaternion(0.716446, -0.591223, 0.318823, 0.188451)
            scale: Qt.vector3d(1, 1, 1)
            source: "qrc:/PainAnalyzer/models/meshes/mesh_0_003_mesh.mesh"
            materials: [
                purple_material
            ]
        }
        Model {
            id: mesh_0_003
            objectName: "Mesh_0.003"
            rotation: Qt.quaternion(0.716446, -0.591223, 0.318823, 0.188451)
            scale: Qt.vector3d(1, 1, 1)
            source: "qrc:/PainAnalyzer/models/meshes/mesh_0_004_mesh.mesh"
            materials: [
                principledMaterial
            ]
        }
        Model {
            id: mesh_0_004
            objectName: "Mesh_0.004"
            rotation: Qt.quaternion(0.716446, -0.591223, 0.318823, 0.188451)
            scale: Qt.vector3d(1, 1, 1)
            source: "qrc:/PainAnalyzer/models/meshes/mesh_0_005_mesh.mesh"
            materials: [
                green_material
            ]
        }
        Model {
            id: mesh_0_005
            objectName: "Mesh_0.005"
            rotation: Qt.quaternion(0.716446, -0.591223, 0.318823, 0.188451)
            scale: Qt.vector3d(1, 1, 1)
            source: "qrc:/PainAnalyzer/models/meshes/mesh_0_006_mesh.mesh"
            materials: [
                blue_material
            ]
        }
        Model {
            id: mesh_0_006
            objectName: "Mesh_0.006"
            rotation: Qt.quaternion(0.716446, -0.591223, 0.318823, 0.188451)
            scale: Qt.vector3d(1, 1, 1)
            source: "qrc:/PainAnalyzer/models/meshes/mesh_0_007_mesh.mesh"
            materials: [
                red_material
            ]
        }
    }

    // Animations:
}
