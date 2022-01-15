import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Controls.Material 2.3
import QtQuick.Controls.Material.impl 2.12
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

RowLayout {
    spacing: 3
    property double value: 0.0
    property int totalValues: 0
    property bool showRating: true
    property bool showTotalValues: true

    Label {
        visible: showRating
        text: value.toFixed(1)
        font {
            family: app.fontSourceRobotoBold.name
            pixelSize: 14*app.scaleFactor
            weight: Font.Bold
        }
        color: app.colorPrimary3
    }

    Item {
        Layout.preferredWidth: showRating ? 4*app.scaleFactor : 0
    }
    
    Gradient {
        id: gradient1
        GradientStop {
            position: 1
            color: app.colorPrimary3
        }
    }
    
    Gradient {
        id: gradient2
        GradientStop {
            position: (value % 1).toFixed(1) <= 0.5 ? 1-(value % 1).toFixed(1) : 0.5
            color: app.colorPrimary3
        }
        GradientStop {
            position: (value % 1).toFixed(1) >= 0.5 ? 1-(value % 1).toFixed(1) : 0.5
            color: "transparent"
        }
    }
    
    Gradient {
        id: gradient3
        GradientStop {
            position: 1
            color: "transparent"
        }
    }
    
    Repeater {
        model: [1,2,3,4,5]
        
        Rectangle {
            width: 9*app.scaleFactor
            height: 9*app.scaleFactor
            radius: 10
            color: modelData <= Math.floor(value) ? app.colorPrimary3 : app.colorPrimary1
            rotation: 90
            gradient: modelData > 0 ? (modelData <= Math.floor(value) ? gradient1 : (modelData > Math.floor(value) + 1 ? gradient3 : gradient2)) : ""
            
            border {
                width: 1*app.scaleFactor
                color: app.colorPrimary3
            }
        }
    }
    
    Item {
        Layout.preferredWidth: 4*app.scaleFactor
    }
    
    Label {
        visible: showTotalValues
        text: totalValues.toString().replace(
                  /(\d)(?=(?:\d{3})+(?:\.|$))|(\.\d\d?)\d*$/g,
                  function(m, s1, s2){
                      return s2 || (s1 + ',');
                  }
                  ) + " Google reviews"
        font {
            family: app.fontSourceRobotoBold.name
            pixelSize: 14*app.scaleFactor
            weight: Font.Bold
        }
        color: app.colorPrimary3
    }
}
