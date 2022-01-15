import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Controls.Material 2.3
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

Rectangle {
    Image {
        anchors.fill: parent
        source: "splash.jpeg"
        fillMode: Image.PreserveAspectCrop

        Rectangle {
            anchors.fill: parent
            color: "#000000"
            opacity: .5
        }

        ColumnLayout {
            anchors.fill: parent
            spacing: 0

            Item {
                Layout.preferredHeight: 60*app.scaleFactor
            }

            Label {
                Layout.leftMargin: 20*app.scaleFactor
                Layout.fillWidth: true
                text: "San Diego"
                style: Text.Outline
                styleColor: "#363A3F"
                font {
                    family: app.fontSourceHindSiliguriSemiBold.name
                    pixelSize: 42*app.scaleFactor
                    weight: Font.Bold
                }
                color: app.colorSecondary1
                lineHeight: 0.8
                layer.enabled: true
                layer.effect: DropShadow {
                    verticalOffset: 2
                    color: "#40000000"
                    radius: 1
                    samples: 3
                }
            }

            Label {
                Layout.leftMargin: 60*app.scaleFactor
                Layout.fillWidth: true
                text: "Field Trip"
                style: Text.Outline
                styleColor: "#363A3F"
                font {
                    family: app.fontSourceHindSiliguriSemiBold.name
                    pixelSize: 42*app.scaleFactor
                    weight: Font.Bold
                }
                color: app.colorSecondary1
                lineHeight: 0.8
                layer.enabled: true
                layer.effect: DropShadow {
                    verticalOffset: 2
                    color: "#40000000"
                    radius: 1
                    samples: 3
                }
            }

            Item {
                Layout.preferredHeight: 50*app.scaleFactor
            }

            Rectangle {
                id: rectDropShadow
                Layout.preferredWidth: 322*app.scaleFactor
                Layout.preferredHeight: 55*app.scaleFactor

                DropShadow {
                    anchors.fill: rectTagline
                    horizontalOffset: 4
                    verticalOffset: 4
                    radius: 8.0
                    samples: 17
                    color: "#40000000"
                    source: rectTagline

                }

                Rectangle {
                    id: rectTagline
                    anchors.fill: parent
                    color: "#1D2125"

                    Label {
                        id: lblTaglineTop
                        width: parent.width
                        horizontalAlignment: Text.AlignHCenter
                        text: "Find events and activities based on"
                        font {
                            family: app.fontSourceRobotoBold.name
                            pixelSize: 18*app.scaleFactor
                            weight: Font.Bold
                        }
                        color: app.colorPrimary3
                        anchors {
                            top: parent.top
                            topMargin: 4*app.scaleFactor
                        }
                    }

                    Rectangle {
                        width: lblTaglineBottom1.contentWidth + lblTaglineBottom2.contentWidth + lblTaglineBottom3.contentWidth + (4*app.scaleFactor)
                        height: lblTaglineBottom1.contentHeight
                        color: "transparent"
                        anchors {
                            top: lblTaglineTop.bottom
                            topMargin: 2*app.scaleFactor
                            horizontalCenter: parent.horizontalCenter
                        }

                        Label {
                            id: lblTaglineBottom1
                            text: "who you're with"
                            font {
                                family: app.fontSourceRobotoBold.name
                                pixelSize: 18*app.scaleFactor
                                weight: Font.Bold
                            }
                            color: app.colorSecondary1
                        }

                        Label {
                            id: lblTaglineBottom2
                            text: "and"
                            font {
                                family: app.fontSourceRobotoBold.name
                                pixelSize: 18*app.scaleFactor
                                weight: Font.Bold
                            }
                            color: app.colorPrimary3
                            anchors {
                                left: lblTaglineBottom1.right
                                leftMargin: 4*app.scaleFactor
                            }
                        }

                        Label {
                            id: lblTaglineBottom3
                            text: "how you feel."
                            font {
                                family: app.fontSourceRobotoBold.name
                                pixelSize: 18*app.scaleFactor
                                weight: Font.Bold
                            }
                            color: app.colorSecondary1
                            anchors {
                                left: lblTaglineBottom2.right
                                leftMargin: 4*app.scaleFactor
                            }
                        }
                    }
                }
            }

            Item {
                Layout.fillHeight: true
            }

            RoundButton {
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: 242*app.scaleFactor
                Layout.preferredHeight: 60*app.scaleFactor
                Material.background: app.colorPrimary3
                Material.foreground: app.colorSecondary1
                text: "Log in"
                radius: 8

                font {
                    family: app.fontSourceRobotoBold.name
                    pixelSize: 16*app.scaleFactor
                    weight: Font.Bold
                    capitalization: Font.MixedCase
                }

                onClicked: {
                    app.stackView.push(containerPage)
                }
            }

            Item {
                Layout.preferredHeight: 40*app.scaleFactor
            }

            Label {
                Layout.alignment: Qt.AlignHCenter
                text: "Don't have an account?"
                font {
                    family: app.fontSourceRobotoBold.name
                    pixelSize: 16*app.scaleFactor
                    weight: Font.Bold
                }
                color: app.colorSecondary1
            }

            Item {
                Layout.preferredHeight: 16*app.scaleFactor
            }

            Rectangle {
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: lblSignUp.contentWidth
                Layout.preferredHeight: lblSignUp.contentHeight
                color: "transparent"

                Label {
                    id: lblSignUp
                    text: "Sign up"
                    font {
                        family: app.fontSourceRobotoBold.name
                        pixelSize: 16*app.scaleFactor
                        weight: Font.Bold
                        underline: true
                    }
                    color: app.colorSecondary1
                }

                MouseArea {
                    anchors.fill: parent

                    onClicked: {
                        console.log("sign up")
                    }
                }
            }

            Item {
                Layout.preferredHeight: 8*app.scaleFactor
            }

            Label {
                Layout.alignment: Qt.AlignHCenter
                text: "or"
                font {
                    family: app.fontSourceRobotoBold.name
                    pixelSize: 16*app.scaleFactor
                    weight: Font.Bold
                }
                color: app.colorSecondary1
            }

            Item {
                Layout.preferredHeight: 8*app.scaleFactor
            }

            Rectangle {
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: lblEnterAsGuest.contentWidth
                Layout.preferredHeight: lblEnterAsGuest.contentHeight
                color: "transparent"

                Label {
                    id: lblEnterAsGuest
                    text: "Enger as guest"
                    font {
                        family: app.fontSourceRobotoBold.name
                        pixelSize: 16*app.scaleFactor
                        weight: Font.Bold
                        underline: true
                    }
                    color: app.colorSecondary1
                }

                MouseArea {
                    anchors.fill: parent

                    onClicked: {
                        console.log("enter as guest")
                    }
                }
            }

            Item {
                Layout.preferredHeight: app.isIos ? (app.hasNotch ? (55+65)*app.scaleFactor : (25+65)*app.scaleFactor) : 65*app.scaleFactor
            }
        }
    }
}
