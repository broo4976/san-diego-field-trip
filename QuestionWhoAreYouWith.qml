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
        width: parent.width
        anchors.centerIn: parent
        spacing: 0
        
        Label {
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter
            text: "Who are you with?"
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
                
                RowLayout {
                    Layout.fillWidth: true
                    
                    Item {
                        Layout.fillWidth: true
                    }
                    
                    ButtonOption {
                        btnText: "My homies"
                        btnImage: "../assets/images/homies.png"
                        
                        onClicked: {
                            app.who = btnText
                            app.filterWith = app.fldHomies + " = 1"
                            swipeView.currentIndex += 1
                        }
                    }
                    
                    Item {
                        Layout.preferredWidth: 22*app.scaleFactor
                    }
                    
                    ButtonOption {
                        btnText: "With bae"
                        btnImage: "../assets/images/bae.png"
                        
                        onClicked: {
                            app.who = btnText
                            app.filterWith = app.fldBae + " = 1"
                            swipeView.currentIndex += 1
                        }
                    }
                    
                    Item {
                        Layout.fillWidth: true
                    }
                }
                
                RowLayout {
                    Layout.fillWidth: true
                    
                    Item {
                        Layout.fillWidth: true
                    }
                    
                    ButtonOption {
                        btnText: "With the kiddos"
                        btnImage: "../assets/images/kids.png"
                        
                        onClicked: {
                            app.who = btnText
                            app.filterWith = app.fldKids + " = 1"
                            swipeView.currentIndex += 1
                        }
                    }
                    
                    Item {
                        Layout.preferredWidth: 22*app.scaleFactor
                    }
                    
                    ButtonOption {
                        btnText: "Parents in town"
                        btnImage: "../assets/images/parents.png"
                        
                        onClicked: {
                            app.who = btnText
                            app.filterWith = app.fldParents + " = 1"
                            swipeView.currentIndex += 1
                        }
                    }
                    
                    Item {
                        Layout.fillWidth: true
                    }
                }
                
                RowLayout {
                    Layout.fillWidth: true
                    
                    Item {
                        Layout.fillWidth: true
                    }
                    
                    ButtonOption {
                        btnText: "Flyin' solo"
                        btnImage: "../assets/images/solo.png"
                        
                        onClicked: {
                            app.who = btnText
                            app.filterWith = app.fldSolo + " = 1"
                            swipeView.currentIndex += 1
                        }
                    }
                    
                    Item {
                        Layout.preferredWidth: 22*app.scaleFactor
                    }
                    
                    ButtonOption {
                        btnText: "The pooch"
                        btnImage: "../assets/images/dogs.png"
                        
                        onClicked: {
                            app.who = btnText
                            app.filterWith = app.fldDogs + " = 1"
                            swipeView.currentIndex += 1
                        }
                    }
                    
                    Item {
                        Layout.fillWidth: true
                    }
                }
            }
        }
    }
    
}
