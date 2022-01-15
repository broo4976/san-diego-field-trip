import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Controls.Material 2.3
import QtQuick.Controls.Material.impl 2.12
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

import Esri.ArcGISRuntime 100.10

Dialog {
    id: dialogInfo
    property string labelText: ""
    width: 270*app.scaleFactor
    height: 180*app.scaleFactor
    x: (parent.width-width)/2
    y: (parent.height-height)/2
    padding: 0
    topPadding: 0
    dim: true
    modal: true
    Material.background: app.colorPrimary2
    
    ToolButton {
        padding: 0
        anchors {
            left: parent.left
            top: parent.top
        }
        
        indicator: Image {
            anchors.centerIn: parent
            source: "../assets/images/close.png"
            width: 25*app.scaleFactor
            height: 25*app.scaleFactor
        }
        
        onClicked: {
            dialogInfo.close()
        }
    }
    
    Label {
        width: parent.width-(30*app.scaleFactor)
        text: labelText
        anchors.centerIn: parent
        wrapMode: Text.WordWrap
        font {
            family: app.fontSourceRobotoRegular.name
            pixelSize: 16*app.scaleFactor
        }
        color: app.colorSecondary1
    }
}
