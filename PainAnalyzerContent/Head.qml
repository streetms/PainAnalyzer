import QtQuick
import QtQuick3D

Node {
    id: node0

    // Resources
    PrincipledMaterial {
        id: principledMaterial4
        metalness: 1
        roughness: 1
        alphaMode: PrincipledMaterial.Opaque
    }

    // Nodes:
    Node {
        id: node_11
        objectName: "Node_1"
        Model {
            id: mesh_02
            objectName: "Mesh_0"
            source: "qrc:/PainAnalyzer/meshes/mesh_0_mesh3.mesh"
            materials: [
                principledMaterial4
            ]
        }
    }

    // Animations:
}
