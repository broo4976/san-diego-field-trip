import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Controls.Material 2.3
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

import Esri.ArcGISRuntime 100.10
import ArcGIS.AppFramework 1.0

import "components"

Page {
    Material.background: app.colorPrimary2

    property FeatureLayer placesFeatureLayer: null

    Component.onCompleted: {
        mapView.map.operationalLayers.clear()
        featureLayerPlaces.definitionExpression = app.fldPlaceId + " = '" + _placeId + "'"
        mapPage.featureLayerPlaces.definitionExpression = app.fldPlaceId + " = '" + _placeId + "'"
        mapView.map.operationalLayers.append(featureTablePlaces.featureLayer)
        var placePoint = ArcGISRuntimeEnvironment.createObject("Point", {json: _geomJson})
        mapView.setViewpointCenterAndScale(placePoint, 80000)
    }

    Keys.onReleased: {
        if (event.key === Qt.Key_Back || event.key === Qt.Key_Escape){
            event.accepted = true
            app.stackView.pop()
        }
    }

    header: Rectangle {
        id: rectHeader
        width: parent.width
        height: 65*app.scaleFactor
        anchors.top: parent.top
        color: "transparent"

        ToolButton {
            id: btnBack
            anchors {
                left: parent.left
                top: parent.top
                margins: 15*app.scaleFactor
            }

            indicator: Image {
                anchors.centerIn: parent
                source: "assets/images/back.png"
                width: 25*app.scaleFactor
                height: 25*app.scaleFactor
            }

            onClicked: {
                listModelPlacesMap.clear()
                app.stackView.pop()
            }
        }

        ToolButton {
            id: btnShare
            anchors {
                right: btnFavorite.left
                rightMargin: 4*app.scaleFactor
                top: parent.top
                topMargin: 15*app.scaleFactor
            }

            indicator: Image {
                anchors.centerIn: parent
                source: "assets/images/share.png"
                width: 25*app.scaleFactor
                height: 25*app.scaleFactor
            }

            onClicked: {
                var inputText = "Check out this place I found on the San Diego Field Trip app:\n" + _placeName + "\n" + _website
                AppFramework.clipboard.share(inputText)
            }
        }

        ToolButton {
            id: btnFavorite
            anchors {
                right: parent.right
                top: parent.top
                margins: 15*app.scaleFactor
            }

            indicator: Image {
                anchors.centerIn: parent
                source: !_favorite ? "assets/images/favorite.png" : "assets/images/favorite_fill.png"
                width: 25*app.scaleFactor
                height: 25*app.scaleFactor
                smooth: true
            }

            onClicked: {
                if (_favorite) {
                    unlikePlace(_placeId)
                    _favorite = false
                }else {
                    likePlace(_placeId)
                    _favorite = true
                }

                // Update in list view model
                for (var i = 0; i < listModelPlacesSorted.count; i++) {
                    if (listModelPlacesSorted.get(i).placeId === _placeId) {
                        listModelPlacesSorted.get(i).favorite = _favorite
                        break
                    }
                }
            }
        }

        Rectangle {
            width: parent.width
            height: 1*app.scaleFactor
            color: app.colorSecondary1
            anchors.bottom: parent.bottom
        }
    }

    Flickable {
        id: flickable
        anchors.fill: parent
        clip: true
        contentHeight: col.height

        ColumnLayout {
            id: col
            width: parent.width
            spacing: 0

            Image {
                Layout.fillWidth: true
                Layout.preferredHeight: 213*app.scaleFactor
                source: _photoUrl
                fillMode: Image.PreserveAspectCrop
            }

            Item {
                Layout.preferredHeight: 16*app.scaleFactor
            }

            Label {
                Layout.leftMargin: 12*app.scaleFactor
                Layout.rightMargin: 16*app.scaleFactor
                Layout.fillWidth: true
                text: _placeName
                font {
                    family: app.fontSourceHindSiliguriSemiBold.name
                    pixelSize: 24*app.scaleFactor
                    weight: Font.Bold
                }
                color: app.colorSecondary1
                wrapMode: Text.WordWrap
                maximumLineCount: 2
                elide: Text.ElideMiddle
                lineHeight: 0.7
            }

            Item {
                Layout.preferredHeight: 8*app.scaleFactor
            }

            RatingsComponent {
                Layout.leftMargin: 12*app.scaleFactor
                value: _rating
                totalValues: _totalRatings
            }

            Item {
                Layout.preferredHeight: 8*app.scaleFactor
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 0

                Item {
                    Layout.preferredWidth: 8*app.scaleFactor
                }

                ButtonWithIcon {
                    Layout.preferredHeight: 50*app.scaleFactor
                    btnText: "Website"
                    btnIcon: "../assets/images/website.png"

                    onClicked: {
                        Qt.openUrlExternally(_website)
                    }
                }

                Item {
                    Layout.preferredWidth: 8*app.scaleFactor
                }

                ButtonWithIcon {
                    Layout.preferredHeight: 50*app.scaleFactor
                    btnText: "Call"
                    btnIcon: "../assets/images/phone_fill.png"

                    onClicked: {
                        Qt.openUrlExternally("tel:%1".arg(_phone))
                    }
                }

                Item {
                    Layout.fillWidth: true
                }
            }

            Item {
                Layout.preferredHeight: 8*app.scaleFactor
            }

            Pane {
                Layout.fillWidth: true
                Layout.preferredHeight: 70*app.scaleFactor
                Material.background: app.colorPrimary1

                ColumnLayout {
                    anchors.fill: parent
                    spacing: 0

                    Item {
                        Layout.fillHeight: true
                    }

                    Label {
                        text: _openNow ? "Open Now" : "Closed Now"
                        font {
                            family: app.fontSourceRobotoBold.name
                            pixelSize: 16*app.scaleFactor
                            weight: Font.Bold
                        }
                        color: _openNow ? app.colorPrimary3 : app.colorSecondary1
                    }

                    Item {
                        Layout.preferredHeight: _arrHours[_todayIndex]["time"] !== "Closed" ? 4*app.scaleFactor : 0
                    }

                    Label {
                        visible: _arrHours[_todayIndex]["time"] !== "Closed"
                        text: _arrHours[_todayIndex]["time"] !== "Closed" ? _arrHours[_todayIndex]["time"] : ""
                        font {
                            family: app.fontSourceRobotoBold.name
                            pixelSize: 16*app.scaleFactor
                            weight: Font.Bold
                        }
                        color: app.colorSecondary1
                    }

                    Item {
                        Layout.fillHeight: true
                    }
                }

                Rectangle {
                    width: 25*app.scaleFactor
                    height: width
                    color: "transparent"
                    anchors {
                        right: parent.right
                        rightMargin: 20*app.scaleFactor
                        verticalCenter: parent.verticalCenter
                    }

                    Image {
                        anchors.fill: parent
                        source: "assets/images/back.png"
                        rotation: 180
                    }
                }

                MouseArea {
                    anchors.fill: parent

                    onClicked: {
                        app.stackView.push(openHoursPage)
                    }
                }
            }

//            Item {
//                Layout.preferredHeight: 12*app.scaleFactor
//            }

//            Label {
//                Layout.leftMargin: 12*app.scaleFactor
//                Layout.fillWidth: true
//                text: "Who's done it?"
//                font {
//                    family: app.fontSourceRobotoBold.name
//                    pixelSize: 18*app.scaleFactor
//                    weight: Font.Bold
//                }
//                color: app.colorSecondary1
//            }

//            Item {
//                Layout.preferredHeight: 4*app.scaleFactor
//            }

//            RowLayout {
//                Layout.fillWidth: true
//                spacing: 0

//                Item {
//                    Layout.preferredWidth: 12*app.scaleFactor
//                }

//                Label {
//                    text: !app.isGuest ? "8 friends have done this." : "You must be logged in to connect with friends."
//                    font {
//                        family: app.fontSourceRobotoRegular.name
//                        pixelSize: 16*app.scaleFactor
//                    }
//                    color: app.colorSecondary1
//                }

//                Item {
//                    Layout.preferredWidth: !app.isGuest ? 4*app.scaleFactor : 0
//                }

//                Rectangle {
//                    visible: !app.isGuest
//                    Layout.preferredWidth: lblSeeAllFriends.contentWidth
//                    Layout.preferredHeight: lblSeeAllFriends.contentHeight
//                    color: "transparent"
//                    Label {
//                        id: lblSeeAllFriends
//                        text: "See all"
//                        font {
//                            family: app.fontSourceRobotoRegular.name
//                            pixelSize: 16*app.scaleFactor
//                            underline: true
//                        }
//                        color: app.colorPrimary3
//                    }

//                    MouseArea {
//                        anchors.fill: parent

//                        onClicked: {
//                            drawerFriends.open()
//                        }
//                    }
//                }
//            }

//            Item {
//                Layout.preferredHeight: 8*app.scaleFactor
//            }

//            RowLayout {
//                visible: !app.isGuest
//                Layout.fillWidth: true

//                Item {
//                    Layout.preferredWidth: 12*app.scaleFactor
//                }

//                Repeater {
//                    model: Object.values(app.friendsPicsObj).slice(0,6)
//                    delegate: RowLayout {
//                        Layout.fillWidth: true
//                        spacing: 0
//                        Rectangle {
//                            Layout.preferredWidth: 50*app.scaleFactor
//                            Layout.preferredHeight: 50*app.scaleFactor
//                            color: "transparent"
//                            Image {
//                                anchors.fill: parent
//                                source: modelData
//                                layer.enabled: true
//                                layer.effect: OpacityMask {
//                                    maskSource: mask
//                                }
//                                fillMode: Image.PreserveAspectCrop
//                                mipmap: true
//                            }
//                            Rectangle {
//                                id: mask
//                                width: 50*app.scaleFactor
//                                height: 50*app.scaleFactor
//                                radius: 45*app.scaleFactor
//                                visible: false
//                            }
//                        }

//                        Item {
//                            Layout.fillWidth: true
//                        }
//                    }
//                }

//                Item {
//                    Layout.preferredWidth: 12*app.scaleFactor
//                }
//            }

//            Item {
//                Layout.preferredHeight: !app.isGuest ? 8*app.scaleFactor : 0
//            }

//            ButtonWithIcon {
//                visible: !app.isGuest
//                Layout.alignment: Qt.AlignHCenter
//                Layout.preferredHeight: 50*app.scaleFactor
//                Layout.preferredWidth: 240*app.scaleFactor
//                btnColor: app.colorPrimary3
//                btnText: "Mark as Done"
//                btnIcon: "../assets/images/done_fill.png"
//                hasBorder: false

//                onClicked: {

//                }
//            }

            Item {
                Layout.preferredHeight: 20*app.scaleFactor
            }

            Label {
                Layout.leftMargin: 12*app.scaleFactor
                Layout.fillWidth: true
                text: "About"
                font {
                    family: app.fontSourceRobotoBold.name
                    pixelSize: 18*app.scaleFactor
                    weight: Font.Bold
                }
                color: app.colorSecondary1
            }

            Item {
                Layout.preferredHeight: 4*app.scaleFactor
            }

            Label {
                id: lblDesc
                Layout.leftMargin: 12*app.scaleFactor
                Layout.rightMargin: 16*app.scaleFactor
                Layout.fillWidth: true
                text: _desc
                font {
                    family: app.fontSourceRobotoRegular.name
                    pixelSize: 16*app.scaleFactor
                }
                color: app.colorSecondary1
                wrapMode: Text.WordWrap
                maximumLineCount: 3
            }

            Item {
                Layout.preferredHeight: lblDesc.truncated ? 3*app.scaleFactor : 0
            }

            Rectangle {
                visible: lblDesc.truncated || lblDesc.lineCount > 3
                Layout.preferredWidth: lblReadMore.contentWidth + imgReadMore.width
                Layout.preferredHeight: lblReadMore.contentHeight
                Layout.leftMargin: 12*app.scaleFactor
                color: "transparent"

                Label {
                    id: lblReadMore
                    text: lblDesc.truncated ? "Read more" : "Read less"
                    font {
                        family: app.fontSourceRobotoRegular.name
                        pixelSize: 16*app.scaleFactor
                        underline: true
                    }
                    color: app.colorPrimary3
                    anchors {
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                    }
                }

                Image {
                    id: imgReadMore
                    width: 16*app.scaleFactor
                    height: 16*app.scaleFactor
                    source: "assets/images/back.png"
                    rotation: lblDesc.truncated ? 270 : 90
                    mipmap: true
                    anchors {
                        left: lblReadMore.right
                        leftMargin: 4*app.scaleFactor
                        verticalCenter: parent.verticalCenter
                    }

                    ColorOverlay {
                        source: imgReadMore
                        anchors.fill: imgReadMore
                        color: app.colorPrimary3
                    }
                }

                MouseArea {
                    anchors.fill: parent

                    onClicked: {
                        if (lblDesc.truncated) {
                            lblDesc.maximumLineCount = 1000
                        }else {
                            lblDesc.maximumLineCount = 3
                        }
                    }
                }
            }

            Item {
                Layout.preferredHeight: 20*app.scaleFactor
            }

            Label {
                Layout.leftMargin: 12*app.scaleFactor
                Layout.fillWidth: true
                text: "The Area"
                font {
                    family: app.fontSourceRobotoBold.name
                    pixelSize: 18*app.scaleFactor
                    weight: Font.Bold
                }
                color: app.colorSecondary1
            }

            Item {
                Layout.preferredHeight: 4*app.scaleFactor
            }

            Rectangle {
                Layout.leftMargin: 12*app.scaleFactor
                Layout.rightMargin: 16*app.scaleFactor
                Layout.fillWidth: true
                Layout.preferredHeight: lblAddress.contentHeight
                color: "transparent"

                Label {
                    id: lblAddress
                    width: parent.width
                    text: _address
                    font {
                        family: app.fontSourceRobotoRegular.name
                        pixelSize: 16*app.scaleFactor
                        underline: true
                    }
                    color: app.colorSecondary1
                    wrapMode: Text.WordWrap
                }

                MouseArea {
                    anchors.fill: parent

                    onClicked: {
                        drawerAddress.open()
                    }
                }
            }

            Item {
                Layout.preferredHeight: 8*app.scaleFactor
            }

            MapView {
                id: mapView
                Layout.fillWidth: true
                Layout.preferredHeight: 216*app.scaleFactor
                attributionTextVisible: false
//                onMousePressedAndHeld: {
//                    flickable.interactive = false
//                }

//                onMousePressed: {
//                    flickable.interactive = false
//                }

//                onMouseReleased: {
//                    flickable.interactive = true
//                }

//                onMouseClicked: {
//                    // Show map page
//                    swipeView.currentIndex += 1

//                    // Select/zoom to point on map
//                    mapPage.selectAndZoomToFeatureFromPlaceDetails(_placeId, _geomJson)

//                    // Update flag
//                    app.mapFromPlaceDetails = true

//                    // Pop details page
//                    app.stackView.pop()
//                }

                Map {
                    BasemapDarkGrayCanvasVector {}
                }

                MouseArea {
                    anchors.fill: parent

                    onClicked: {
                        // Show map page
                        if (swipeView.currentIndex !== swipeView.count-1) {
                            swipeView.currentIndex += 1
                        }

                        // Select/zoom to point on map
                        mapPage.selectAndZoomToFeatureFromPlaceDetails(_placeId, _geomJson)

                        // Update flag
                        app.mapFromPlaceDetails = true

                        // Pop details page
                        app.stackView.pop()
                    }
                }
            }

            Item {
                Layout.preferredHeight: 20*app.scaleFactor
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 0

                Label {
                    Layout.leftMargin: 12*app.scaleFactor
                    text: "Tips"
                    font {
                        family: app.fontSourceRobotoBold.name
                        pixelSize: 18*app.scaleFactor
                        weight: Font.Bold
                    }
                    color: app.colorSecondary1
                }

                Item {
                    Layout.preferredWidth: 4*app.scaleFactor
                }

                Rectangle {
                    Layout.preferredWidth: 20*app.scaleFactor
                    Layout.preferredHeight: 20*app.scaleFactor
                    color: "transparent"

                    Image {
                        anchors.fill: parent
                        source: "assets/images/info_fill.png"
                        mipmap: true
                    }

                    MouseArea {
                        anchors.fill: parent

                        onClicked: {
                            dialogInfo.labelText = "Tips are things you should know before you go (bring a chair, cash only, etc)."
                            dialogInfo.open()
                        }
                    }
                }
            }

            Item {
                Layout.preferredHeight: 4*app.scaleFactor
            }

            Label {
                Layout.leftMargin: 12*app.scaleFactor
                Layout.rightMargin: 16*app.scaleFactor
                Layout.fillWidth: true
                text: "There are currently no tips for " + _placeName + "."
                font {
                    family: app.fontSourceRobotoRegular.name
                    pixelSize: 14*app.scaleFactor
                }
                color: app.colorSecondary1
                wrapMode: Text.WordWrap
            }

            Item {
                Layout.preferredHeight: 16*app.scaleFactor
            }

            Label {
                Layout.alignment: Qt.AlignHCenter
                text: "Have a useful tip for other users?"
                font {
                    family: app.fontSourceRobotoRegular.name
                    pixelSize: 16*app.scaleFactor
                }
                color: app.colorSecondary1
            }

            Item {
                Layout.preferredHeight: 8*app.scaleFactor
            }

            ButtonWithIcon {
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: 240*app.scaleFactor
                Layout.preferredHeight: 50*app.scaleFactor
                btnText: "Suggest a tip for this listing"

                onClicked: {
                    dialogInfo.labelText = "Under development - this feature will open a form for the user to enter/submit a tip."
                    dialogInfo.open()
                }
            }

            Item {
                Layout.preferredHeight: 20*app.scaleFactor
            }

            Label {
                Layout.leftMargin: 12*app.scaleFactor
                text: "Reviews"
                font {
                    family: app.fontSourceRobotoBold.name
                    pixelSize: 18*app.scaleFactor
                    weight: Font.Bold
                }
                color: app.colorSecondary1
            }

//            Item {
//                Layout.preferredHeight: 4*app.scaleFactor
//            }

//            RatingsComponent {
//                Layout.leftMargin: 12*app.scaleFactor
//                value: _rating
//                totalValues: _rating
//                showTotalValues: false
//            }

            Item {
                Layout.preferredHeight: 12*app.scaleFactor
            }

            Repeater {
                id: repeaterReviews
                model: listModelReviewsSorted

                delegate: ColumnLayout {
                    width: parent.width
                    spacing: 0

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 0

                        Rectangle {
                            Layout.leftMargin: 12*app.scaleFactor
                            Layout.preferredWidth: 50*app.scaleFactor
                            Layout.preferredHeight: 50*app.scaleFactor
                            color: "transparent"
                            Image {
                                anchors.fill: parent
                                source: authorPhoto
                                layer.enabled: true
                                layer.effect: OpacityMask {
                                    maskSource: maskReview
                                }
                                fillMode: Image.PreserveAspectCrop
                                mipmap: true
                            }
                            Rectangle {
                                id: maskReview
                                width: 50*app.scaleFactor
                                height: 50*app.scaleFactor
                                radius: 45*app.scaleFactor
                                visible: false
                            }
                        }

                        Item {
                            Layout.preferredWidth: 12*app.scaleFactor
                        }

                        Label {
                            text: author
                            font {
                                family: app.fontSourceRobotoBold.name
                                pixelSize: 16*app.scaleFactor
                                weight: Font.Bold
                            }
                            color: app.colorSecondary1
                        }
                    }

                    Item {
                        Layout.preferredHeight: 12*app.scaleFactor
                    }

                    RatingsComponent {
                        Layout.leftMargin: 12*app.scaleFactor
                        value: userRating
                        totalValues: userRating
                        showTotalValues: false
                    }

                    Item {
                        Layout.preferredHeight: 8*app.scaleFactor
                    }

                    Label {
                        Layout.leftMargin: 12*app.scaleFactor
                        text: reviewTime
                        font {
                            family: app.fontSourceRobotoBold.name
                            pixelSize: 14*app.scaleFactor
                            weight: Font.Bold
                        }
                        color: app.colorSecondary1
                    }

                    Item {
                        Layout.preferredHeight: 4*app.scaleFactor
                    }

                    Label {
                        id: lblReview
                        Layout.leftMargin: 12*app.scaleFactor
                        Layout.rightMargin: 16*app.scaleFactor
                        Layout.fillWidth: true
                        text: review
                        font {
                            family: app.fontSourceRobotoRegular.name
                            pixelSize: 16*app.scaleFactor
                        }
                        color: app.colorSecondary1
                        wrapMode: Text.WordWrap
                        maximumLineCount: 3
                    }

                    Item {
                        Layout.preferredHeight: lblDesc.truncated ? 3*app.scaleFactor : 0
                    }

                    Rectangle {
                        visible: lblReview.truncated || lblReview.lineCount > 3
                        Layout.preferredWidth: lblReadMore2.contentWidth + imgReadMore2.width
                        Layout.preferredHeight: lblReadMore2.contentHeight
                        Layout.leftMargin: 12*app.scaleFactor
                        color: "transparent"

                        Label {
                            id: lblReadMore2
                            text: lblReview.truncated ? "Read more" : "Read less"
                            font {
                                family: app.fontSourceRobotoRegular.name
                                pixelSize: 16*app.scaleFactor
                                underline: true
                            }
                            color: app.colorPrimary3
                            anchors {
                                left: parent.left
                                verticalCenter: parent.verticalCenter
                            }
                        }

                        Image {
                            id: imgReadMore2
                            width: 16*app.scaleFactor
                            height: 16*app.scaleFactor
                            source: "assets/images/back.png"
                            rotation: lblReview.truncated ? 270 : 90
                            mipmap: true
                            anchors {
                                left: lblReadMore2.right
                                leftMargin: 4*app.scaleFactor
                                verticalCenter: parent.verticalCenter
                            }

                            ColorOverlay {
                                source: imgReadMore2
                                anchors.fill: imgReadMore2
                                color: app.colorPrimary3
                            }
                        }

                        MouseArea {
                            anchors.fill: parent

                            onClicked: {
                                if (lblReview.truncated) {
                                    lblReview.maximumLineCount = 1000
                                }else {
                                    lblReview.maximumLineCount = 3
                                }
                            }
                        }
                    }

                    Item {
                        Layout.preferredHeight: 16*app.scaleFactor
                    }

                    Rectangle {
                        Layout.alignment: Qt.AlignHCenter
                        Layout.preferredWidth: parent.width-(24*app.scaleFactor)
                        Layout.preferredHeight: 1*app.scaleFactor
                        color: app.colorSecondary1
                    }

                    Item {
                        Layout.preferredHeight: 16*app.scaleFactor
                    }
                }
            }

            Item {
                Layout.preferredHeight: listModelReviewsSorted.count >= 6 ? 24*app.scaleFactor : 0
            }

            Item {
                Layout.preferredHeight: 80*app.scaleFactor
            }

            Label {
                Layout.alignment: Qt.AlignHCenter
                text: "Anything missing or inaccurate?"
                font {
                    family: app.fontSourceRobotoRegular.name
                    pixelSize: 16*app.scaleFactor
                }
                color: app.colorSecondary1
            }

            Item {
                Layout.preferredHeight: 8*app.scaleFactor
            }

            ButtonWithIcon {
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: 240*app.scaleFactor
                Layout.preferredHeight: 50*app.scaleFactor
                btnText: "Improve this listing"

                onClicked: {
                    dialogInfo.labelText = "Under development - this feature will open a form for the user to enter/submit corrections to the listing."
                    dialogInfo.open()
                }
            }

            Item {
                Layout.preferredHeight: app.isIos ? (app.hasNotch ? (55+32)*app.scaleFactor : (25+32)*app.scaleFactor) : 32*app.scaleFactor
            }
        }
    }

    DialogInfo {
        id: dialogInfo
    }

    Drawer {
        id: drawerFriends
        width: parent.width
        height: app.isIos ? parent.height - (45*app.scaleFactor) : parent.height - (25*app.scaleFactor)
        edge: Qt.BottomEdge
        dragMargin: 0
        Material.background: app.colorPrimary2

        Rectangle {
            id: rectHeaderDrawerFriends
            width: parent.width
            height: 65*app.scaleFactor
            color: "transparent"

            ToolButton {
                anchors {
                    left: parent.left
                    top: parent.top
                    margins: 15*app.scaleFactor
                }

                indicator: Image {
                    anchors.centerIn: parent
                    source: "assets/images/close.png"
                    width: 25*app.scaleFactor
                    height: 25*app.scaleFactor
                }

                onClicked: {
                    drawerFriends.close()
                }
            }
        }

        ColumnLayout {
            width: parent.width
            anchors {
                top: rectHeaderDrawerFriends.bottom
                topMargin: 32*app.scaleFactor
            }
            spacing: 0

            Label {
                Layout.fillWidth: true
                Layout.leftMargin: 16*app.scaleFactor
                Layout.rightMargin: 16*app.scaleFactor
                text: "Friends who have done this activity"
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

            ListView {
                Layout.fillWidth: true
                Layout.preferredHeight: drawerFriends.height - rectHeaderDrawerFriends.height - (85*app.scaleFactor)
                Layout.leftMargin: 16*app.scaleFactor
                Layout.rightMargin: 16*app.scaleFactor
                clip: true
                model: app.listModelFriendsPics
                spacing: 8*app.scaleFactor
                delegate: RowLayout {
                    Layout.fillWidth: true
                    spacing: 0
                    Rectangle {
                        Layout.preferredWidth: 50*app.scaleFactor
                        Layout.preferredHeight: 50*app.scaleFactor
                        color: "transparent"
                        Image {
                            anchors.fill: parent
                            source: pic
                            layer.enabled: true
                            layer.effect: OpacityMask {
                                maskSource: mask2
                            }
                            fillMode: Image.PreserveAspectCrop
                            mipmap: true
                        }
                        Rectangle {
                            id: mask2
                            width: 50*app.scaleFactor
                            height: 50*app.scaleFactor
                            radius: 45*app.scaleFactor
                            visible: false
                        }
                    }

                    Item {
                        Layout.preferredWidth: 8*app.scaleFactor
                    }

                    Label {
                        text: name
                        font {
                            family: app.fontSourceRobotoRegular.name
                            pixelSize: 16*app.scaleFactor
                        }
                        color: app.colorSecondary1
                    }

                    Item {
                        Layout.fillWidth: true
                    }
                }
            }
        }
    }

    Drawer {
        id: drawerAddress
        width: parent.width
        height: app.isIos ? (app.hasNotch ? (55+182)*app.scaleFactor : (25+182)*app.scaleFactor) : 122*app.scaleFactor
        edge: Qt.BottomEdge
        dragMargin: 0
        Material.background: app.colorPrimary1

        ColumnLayout {
            anchors.fill: parent
            spacing: 0

            ItemDelegate {
                Layout.fillWidth: true
                Layout.preferredHeight: 60*app.scaleFactor
                indicator: Label {
                    anchors.centerIn: parent
                    text: "Open in Google Maps"
                    font {
                        family: app.fontSourceRobotoRegular.name
                        pixelSize: 16*app.scaleFactor
                    }
                    Material.foreground: app.colorSecondary1
                }

                onClicked: {
                    var directionsLink = app.directionsGoogleUrl + "&destination=" + _address
                    Qt.openUrlExternally(directionsLink)
                    drawerAddress.close()
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: app.isIos ? 1*app.scaleFactor : 0
                color: app.colorSecondary1
            }

            ItemDelegate {
                visible: app.isIos
                Layout.fillWidth: true
                Layout.preferredHeight: 60*app.scaleFactor
                indicator: Label {
                    anchors.centerIn: parent
                    text: "Open in Maps"
                    font {
                        family: app.fontSourceRobotoRegular.name
                        pixelSize: 16*app.scaleFactor
                    }
                    Material.foreground: app.colorSecondary1
                }

                onClicked: {
                    var directionsLink = app.directionsAppleUrl + "daddr=" + _address + "&dirflg=d"
                    Qt.openUrlExternally(directionsLink)
                    drawerAddress.close()
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 1*app.scaleFactor
                color: app.colorSecondary1
            }

            ItemDelegate {
                Layout.fillWidth: true
                Layout.preferredHeight: 60*app.scaleFactor
                indicator: Label {
                    anchors.centerIn: parent
                    text: "Copy address"
                    font {
                        family: app.fontSourceRobotoRegular.name
                        pixelSize: 16*app.scaleFactor
                    }
                    Material.foreground: app.colorSecondary1
                }

                onClicked: {
                    AppFramework.clipboard.copy(lblAddress.text)
                    drawerAddress.close()
                }
            }
        }
    }

    Component {
        id: openHoursPage

        OpenHoursPage {}
    }

}
