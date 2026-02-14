import QtQuick 2.0;
import calamares.slideshow 1.0;

Presentation
{
    id: presentation

    function nextSlide() {
        console.log("QML Component (default slideshow) Next slide");
        presentation.goToNextSlide();
    }

    Timer {
        id: advanceTimer
        interval: 5000
        running: presentation.activatedInCalamares
        repeat: true
        onTriggered: nextSlide()
    }

    Slide {
        anchors.fill: parent
        Image {
            anchors.fill: parent
            source: "dark.png"
            fillMode: Image.PreserveAspectCrop
        }
        Rectangle {
            anchors.fill: parent
            color: "#80000000"
            Text {
                anchors.centerIn: parent
                text: "Добро пожаловать в SunriseOS!"
                font.pixelSize: 48
                color: "white"
            }
        }
    }

    Slide {
        anchors.fill: parent
        Image {
            anchors.fill: parent
            source: "dark.png"
            fillMode: Image.PreserveAspectCrop
        }
        Rectangle {
            anchors.fill: parent
            color: "#80000000"
            Text {
                anchors.centerIn: parent
                text: "Основан на Arch Linux"
                font.pixelSize: 48
                color: "white"
            }
        }
    }

    Slide {
        anchors.fill: parent
        Image {
            anchors.fill: parent
            source: "dark.png"
            fillMode: Image.PreserveAspectCrop
        }
        Rectangle {
            anchors.fill: parent
            color: "#80000000"
            Text {
                anchors.centerIn: parent
                text: "С рабочим столом GNOME"
                font.pixelSize: 48
                color: "white"
            }
        }
    }
}
