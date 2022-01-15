import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Controls.Material 2.3
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

import QtPositioning 5.12

import Esri.ArcGISRuntime 100.10

import "components"


Item {
    ColumnLayout {
        anchors.centerIn: parent
        spacing: 0
        
        Label {
            text: "How do you feel?"
            font {
                family: app.fontSourceHindSiliguriSemiBold.name
                pixelSize: 26*app.scaleFactor
            }
            color: app.colorSecondary1
        }
        
        Item {
            Layout.preferredHeight: 30*app.scaleFactor
        }
        
        Rectangle {
            Layout.alignment: Qt.AlignHCenter
            Layout.fillWidth: true
            Layout.preferredHeight: 384*app.scaleFactor
            color: "transparent"
            
            ColumnLayout {
                anchors.fill: parent
                
                ButtonOption {
                    Layout.alignment: Qt.AlignHCenter
                    btnWidth: 190*app.scaleFactor
                    btnHeight: 110*app.scaleFactor
                    btnText: "Make me sweat"
                    btnImage: "../assets/images/make_me_sweat.png"
                    
                    onClicked: {
                        app.active = btnText
                        app.filterActive = app.fldActivityLevel + " > 3"
                        swipeView.currentIndex += 1
                    }
                }
                
                ButtonOption {
                    Layout.alignment: Qt.AlignHCenter
                    btnWidth: 190*app.scaleFactor
                    btnHeight: 110*app.scaleFactor
                    btnText: "Low energy"
                    btnImage: "../assets/images/low_energy.png"
                    
                    onClicked: {
                        app.active = btnText
                        app.filterActive = app.fldActivityLevel + " < 3"
                        swipeView.currentIndex += 1
                    }
                }
                
                ButtonOption {
                    Layout.alignment: Qt.AlignHCenter
                    btnWidth: 190*app.scaleFactor
                    btnHeight: 110*app.scaleFactor
                    btnText: "Something in between"
                    btnImage: "../assets/images/in_between.png"
                    
                    onClicked: {
                        app.active = btnText
                        app.filterActive = app.fldActivityLevel + " > 1 AND " + app.fldActivityLevel + " < 5"
                        swipeView.currentIndex += 1
                    }
                }
            }
        }
    }
    
}
