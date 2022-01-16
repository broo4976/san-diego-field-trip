import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Controls.Material 2.3
import QtQuick.Controls.Material.impl 2.12
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.4
import QtQuick.Controls.impl 2.4

RoundButton {
    id: control
    property string btnText: ""
    property string btnIcon: ""
    property color btnColor: app.colorPrimary1
    property bool hasBorder: true
    //Material.background: btnColor
    //Material.foreground: app.colorSecondary1
    Material.foreground: control.checked || control.highlighted ? control.palette.brightText :
                                                                  control.flat && !control.down ? (control.visualFocus ? control.palette.highlight : control.palette.windowText) : control.palette.buttonText
    display: AbstractButton.TextBesideIcon
    text: btnText
    palette {
        button: btnColor
        buttonText: app.colorSecondary1
    }
    background: Rectangle {
        color: Color.blend(control.checked || control.highlighted ? control.palette.dark : control.palette.button,
                           control.palette.mid, control.down ? 0.5 : 0.0)
        radius: 16
        border {
            width: hasBorder ? 1*app.scaleFactor : 0
            color: app.colorSecondary1
        }
    }

//    indicator: RowLayout {
//        id: row
//        spacing: 0

//        Item {
//            Layout.preferredWidth: 4*app.scaleFactor
//        }

//        Image {
//            Layout.preferredWidth: 25*app.scaleFactor
//            Layout.preferredHeight: 25*app.scaleFactor
//            mipmap: true
//            source: btnIcon
//        }

//        Item {
//            Layout.preferredWidth: 4*app.scaleFactor
//        }

//        Label {
//            text: btnText
//            font {
//                family: app.fontSourceRobotoBold.name
//                pixelSize: 16*app.scaleFactor
//                weight: Font.Bold
//                capitalization: Font.MixedCase
//            }
//            color: app.colorSecondary1
//        }

//        Item {
//            Layout.preferredWidth: 4*app.scaleFactor
//        }
//    }
    
    font {
        family: app.fontSourceRobotoBold.name
        pixelSize: 16*app.scaleFactor
        weight: Font.Bold
        capitalization: Font.MixedCase
    }
    
    icon {
        width: 25*app.scaleFactor
        height: 25*app.scaleFactor
        source: btnIcon
        color: control.checked || control.highlighted ? control.palette.brightText :
                        control.flat && !control.down ? (control.visualFocus ? control.palette.highlight : control.palette.windowText) : control.palette.buttonText
    }
}
