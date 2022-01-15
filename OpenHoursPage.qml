import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Controls.Material 2.3
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

Page {
    Material.background: app.colorPrimary2

    Keys.onReleased: {
        if (event.key === Qt.Key_Back || event.key === Qt.Key_Escape){
            event.accepted = true
            app.stackView.pop()
        }
    }

    header: Rectangle {
        id: rectHeader
        width: parent.width
        height: 65*app.scaleFactor
        anchors.top: parent.top
        color: "transparent"

        ToolButton {
            id: btnBack
            anchors {
                left: parent.left
                top: parent.top
                margins: 15*app.scaleFactor
            }

            indicator: Image {
                anchors.centerIn: parent
                source: "assets/images/back.png"
                width: 25*app.scaleFactor
                height: 25*app.scaleFactor
            }

            onClicked: {
                app.stackView.pop()
            }
        }
    }

    ColumnLayout {
        width: parent.width
        spacing: 0

        Item {
            Layout.preferredHeight: 12*app.scaleFactor
        }

        Label {
            Layout.leftMargin: 16*app.scaleFactor
            text: "Opening hours"
            font {
                family: app.fontSourceHindSiliguriSemiBold.name
                pixelSize: 24*app.scaleFactor
                weight: Font.Bold
            }
            color: app.colorSecondary1
        }

        Item {
            Layout.preferredHeight: 24*app.scaleFactor
        }

        Repeater {
            model: _arrHours
            delegate: ColumnLayout {
                width: parent.width
                spacing: 0
                Label {
                    Layout.leftMargin: 24*app.scaleFactor
                    text: modelData["day"]
                    font {
                        family: app.fontSourceRobotoBold.name
                        pixelSize: 16*app.scaleFactor
                        weight: Font.Bold
                    }
                    color: !modelData["currentDay"] ? app.colorSecondary1 : app.colorPrimary3
                }

                Item {
                    Layout.preferredHeight: 4*app.scaleFactor
                }

                Label {
                    Layout.leftMargin: 24*app.scaleFactor
                    text: modelData["time"]
                    font {
                        family: app.fontSourceRobotoRegular.name
                        pixelSize: 16*app.scaleFactor
                    }
                    color: !modelData["currentDay"] ? app.colorSecondary1 : app.colorPrimary3
                }

                Item {
                    Layout.preferredHeight: 20*app.scaleFactor
                }
            }
        }
    }

}
