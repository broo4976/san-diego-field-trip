import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Controls.Material 2.3
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0


RoundButton {
    id: btnOption
    property double btnWidth: 150*app.scaleFactor
    property double btnHeight: 110*app.scaleFactor
    property string btnText: ""
    property string btnImage: ""
    Layout.preferredWidth: btnWidth
    Layout.preferredHeight: btnHeight
    Material.background: app.colorPrimary3
    radius: 6
    display: AbstractButton.TextUnderIcon
    indicator: Rectangle {
        anchors.fill: parent
        color: "transparent"
        Image {
            id: btnImg
            width: 60*app.scaleFactor
            height: 60*app.scaleFactor
            source: btnOption.btnImage
            mipmap: true
            anchors {
                horizontalCenter: parent.horizontalCenter
                top: parent.top
                topMargin: 11*app.scaleFactor
            }
        }
        
        Label {
            text: btnOption.btnText
            font {
                family: app.fontSourceRobotoBold.name
                pixelSize: 16*app.scaleFactor
                weight: Font.Bold
            }
            color: app.colorSecondary1
            anchors {
                horizontalCenter: parent.horizontalCenter
                top: btnImg.bottom
                topMargin: 4*app.scaleFactor
            }
        }
    }
}
