import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Controls.Material 2.3
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0


Page {

    StackLayout {
        id: stackLayout
        anchors.fill: parent
        currentIndex: bottomBarNav.currentIndex

        HomePage {
            id: homePage
        }

//        DealsPage {
//            id: dealsPage
//        }

        FeaturedPage {
            id: featuredPage
        }

        FavoritesPage {
            id: favoritesPage
        }

        ProfilePage {
            id: profilePage
        }
    }


    footer: ColumnLayout {
        visible: homePage.swipeView.currentIndex < homePage.swipeView.count-1
        height: app.isIos ? (app.hasNotch ? (55+60)*app.scaleFactor : (25+60)*app.scaleFactor) : 60*app.scaleFactor
        spacing: 0

        TabBar {
            id: bottomBarNav
            Layout.fillWidth: true
            Layout.preferredHeight: 56*app.scaleFactor
            Material.background: app.colorPrimary1
            Material.accent: app.colorPrimary3

            Repeater {
                model: [
                    {
                        buttonText: "Home",
                        buttonImage: "assets/images/home.png",
                        buttonImageSelected: "assets/images/home_fill.png"
                    },
//                    {
//                        buttonText: "Deals",
//                        buttonImage: "assets/images/deal.png",
//                        buttonImageSelected: "assets/images/deal_fill.png"
//                    },
                    {
                        buttonText: "Featured",
                        buttonImage: "assets/images/star.png",
                        buttonImageSelected: "assets/images/star_fill.png"
                    },
                    {
                        buttonText: "Favorites",
                        buttonImage: "assets/images/favorite.png",
                        buttonImageSelected: "assets/images/favorite_fill.png"
                    },
                    {
                        buttonText: "Profile",
                        buttonImage: "assets/images/profile.png",
                        buttonImageSelected: "assets/images/profile_fill.png"
                    }
                ]

                TabButton {
                    display: AbstractButton.TextUnderIcon
                    spacing: 6*app.scaleFactor
                    topPadding: 4*app.scaleFactor
                    bottomPadding: 4*app.scaleFactor
                    leftPadding: 0
                    rightPadding: 0
                    Material.accent: index === bottomBarNav.currentIndex ? app.colorPrimary3 : app.colorSecondary1
                    indicator: Rectangle {
                        anchors.fill: parent
                        color: "transparent"
                        Image {
                            id: imgButton
                            width: 25*app.scaleFactor
                            height: 25*app.scaleFactor
                            source: index === bottomBarNav.currentIndex ? modelData.buttonImageSelected: modelData.buttonImage
                            mipmap: true
                            smooth: true
                            anchors {
                                top: parent.top
                                topMargin: 3*app.scaleFactor
                                horizontalCenter: parent.horizontalCenter
                            }
                        }
                        ColorOverlay {
                            anchors.fill: imgButton
                            color: index === bottomBarNav.currentIndex ? app.colorPrimary3 : app.colorSecondary1
                            source: imgButton
                        }

                        Label {
                            text: modelData.buttonText
                            anchors {
                                bottom: parent.bottom
                                bottomMargin: 5*app.scaleFactor
                                horizontalCenter: parent.horizontalCenter
                            }

                            font {
                                family: index === bottomBarNav.currentIndex ? app.fontSourceRobotoBold.name : app.fontSourceRobotoRegular.name
                                pixelSize: 12*app.scaleFactor
                                letterSpacing: 0.4*app.scaleFactor
                                bold: index === bottomBarNav.currentIndex ? true : false
                                capitalization: Font.MixedCase
                            }
                            color: index === bottomBarNav.currentIndex ? app.colorPrimary3 : app.colorSecondary1
                        }
                    }
                }
            }
        }

        Rectangle {
            color: app.colorPrimary1
            z: 10
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
    }

}
