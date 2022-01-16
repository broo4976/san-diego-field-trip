import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Controls.Material 2.3
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

Rectangle {
    anchors.fill: parent
    color: app.colorPrimary2

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        Item {
            Layout.fillHeight: true
        }

        Label {
            Layout.alignment: Qt.AlignHCenter
            text: "App version: " + app.info.version
            font {
                family: app.fontSourceRobotoRegular.name
                pixelSize: 16*app.scaleFactor
            }
            color: app.colorPrimary3
            horizontalAlignment: Text.AlignHCenter
        }

        Item {
            Layout.preferredHeight: 8*app.scaleFactor
        }

        RowLayout {
            Layout.fillWidth: true

            Item {
                Layout.fillWidth: true
            }

            Label {
                text: "App icons made by "
                font {
                    family: app.fontSourceRobotoBold.name
                    pixelSize: 14*app.scaleFactor
                    weight: Font.Bold
                }
                color: app.colorPrimary3
            }

            Rectangle {
                Layout.preferredWidth: lblFreepik.contentWidth
                Layout.preferredHeight: lblFreepik.contentHeight
                color: "transparent"

                Label {
                    id: lblFreepik
                    text: "Freepik"
                    font {
                        family: app.fontSourceRobotoBold.name
                        pixelSize: 14*app.scaleFactor
                        weight: Font.Bold
                        underline: true
                    }
                    color: app.colorSecondary1
                    horizontalAlignment: Text.AlignHCenter
                }

                MouseArea {
                    anchors.fill: parent

                    onClicked: {
                        Qt.openUrlExternally("https://www.freepik.com/")
                    }
                }
            }

            Item {
                Layout.fillWidth: true
            }
        }

        Item {
            Layout.preferredHeight: 12*app.scaleFactor
        }
    }

}
