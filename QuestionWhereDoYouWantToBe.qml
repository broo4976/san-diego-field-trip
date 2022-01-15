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
            Layout.fillWidth: true
            text: "Where do you want to be?"
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
                    btnText: "Outside"
                    btnImage: "../assets/images/outside.png"
                    
                    onClicked: {
                        app.where = btnText
                        app.filterVenue = app.fldVenue + " <> 'Indoors'"
                        app.filterMaster = app.filterWith + " AND " + app.filterActive + " AND " + app.filterVenue + " AND " + app.filterStatus
                        getResults()
                    }
                }
                
                ButtonOption {
                    Layout.alignment: Qt.AlignHCenter
                    btnWidth: 190*app.scaleFactor
                    btnHeight: 110*app.scaleFactor
                    btnText: "Inside"
                    btnImage: "../assets/images/inside.png"
                    
                    onClicked: {
                        app.where = btnText
                        app.filterVenue = app.fldVenue + " <> 'Outdoors'"
                        app.filterMaster = app.filterWith + " AND " + app.filterActive + " AND " + app.filterVenue + " AND " + app.filterStatus
                        getResults()
                    }
                }
                
                ButtonOption {
                    Layout.alignment: Qt.AlignHCenter
                    btnWidth: 190*app.scaleFactor
                    btnHeight: 110*app.scaleFactor
                    btnText: "Either"
                    btnImage: "../assets/images/either.png"
                    
                    onClicked: {
                        app.where = btnText
                        app.filterVenue = ""
                        app.filterMaster = app.filterWith + " AND " + app.filterActive + " AND " + app.filterStatus
                        getResults()
                    }
                }
            }
        }
    }
    
}
