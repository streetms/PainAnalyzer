
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects

Button {
    id: root

    property string title
    property string subtitle
    property color gradientStart
    property color gradientEnd

    Layout.fillWidth: true
    Layout.preferredHeight: 150

    background: Rectangle {
        radius: 22
        gradient: Gradient {
            GradientStop { position: 0.0; color: root.gradientStart }
            GradientStop { position: 1.0; color: root.gradientEnd }
        }

        layer.enabled: true
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowBlur: 0.6
            shadowColor: "#40000000"
            shadowVerticalOffset: 6
        }
    }

    contentItem: RowLayout {
        anchors.fill: parent
        anchors.margins: 24

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 6

            Label {
                text: root.title
                font.pixelSize: 22
                font.bold: true
                color: "#1f2937"
            }

            Label {
                text: root.subtitle
                font.pixelSize: 16
                color: "#6b7280"
                wrapMode: Text.WordWrap
            }
        }
    }
}