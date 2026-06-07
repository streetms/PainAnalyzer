import QtQuick
import QtQuick.Controls

Item {
    width: parent.width
    height: 52
    property int radius: 13
    property alias value : painSlider.value
    Rectangle {
        id: track
        x: 0
        y: 8
        width: parent.width
        height: parent.radius*2
        radius: parent.radius

        gradient: Gradient {
            orientation: Gradient.Horizontal
            GradientStop {
                position: 0.0
                color: "#9BE07A"
            }
            GradientStop {
                position: 0.55
                color: "#E7D36A"
            }
            GradientStop {
                position: 1.0
                color: "#B9877F"
            }
        }
    }

    Slider {
        id: painSlider
        anchors.fill: track

        from: 0
        to: 10
        stepSize: 1

        background: Item { }
        implicitHeight: track.height

        handle: Rectangle {
            width: track.radius*2
            height: track.radius*2
            radius: track.radius
            color: "#E00000"
            border.width: 1
            border.color: "#B3000059"

            y: (parent.height - height) / 2

            // ✅ правильное движение
            x: painSlider.leftPadding +
                painSlider.visualPosition *
                (painSlider.availableWidth - width)
        }

        onValueChanged: page.painLevel = Math.round(value)
    }

}