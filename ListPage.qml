import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Controls.Material 2.3
import QtQuick.Controls.Material.impl 2.12
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.4
import QtQuick.Controls.impl 2.4

import Esri.ArcGISRuntime 100.10

import "components"

Rectangle {
    color: app.colorPrimary2

    signal mapButtonClicked()
    property string sortByLocal: app.sortBy
    property string searchAddressLocal: app.searchedAddress

    property string currentLocatorTaskId: ""

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        RowLayout {
            Layout.fillWidth: true
            spacing: 0

            Item {
                Layout.fillWidth: true
            }

            ButtonWithIcon {
                Layout.preferredHeight: 50*app.scaleFactor
                btnText: "Options"
                btnIcon: "../assets/images/options.png"

                onClicked: {
                    drawerOptions.open()
                }
            }

            Item {
                Layout.preferredWidth: 4*app.scaleFactor
            }

            ButtonWithIcon {
                Layout.preferredHeight: 50*app.scaleFactor
                btnText: app.todayDate + " - " + app.tomorrowDate
                btnIcon: "../assets/images/calendar_fill.png"
                onClicked: {
                    dialogInfo.labelText = "This will open a drawer that will allow the user to select dates for events. Event data is not currently available in the app."
                    dialogInfo.open()
                }
            }

            Item {
                Layout.preferredWidth: 4*app.scaleFactor
            }

            ButtonWithIcon{
                Layout.preferredHeight: 50*app.scaleFactor
                btnText: "Map"
                btnIcon: "../assets/images/map_fill.png"
                btnColor: app.colorPrimary3
                hasBorder: false

                onClicked: {
                    mapButtonClicked()
                }
            }

            Item {
                Layout.fillWidth: true
            }
        }

        Item {
            Layout.preferredHeight: 16*app.scaleFactor
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 1*app.scaleFactor
            color: app.colorSecondary1
            opacity: 0.6
        }

        Item {
            Layout.preferredHeight: 16*app.scaleFactor
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 0
            visible: listModelPlacesSorted.count > 0

            Item {
                Layout.preferredWidth: 20*app.scaleFactor
            }

            Label {
                Layout.alignment: Qt.AlignVCenter
                text: listModelPlacesSorted.count === 1 ? listModelPlacesSorted.count + " result" : listModelPlacesSorted.count + " results sorted by "
                font {
                    family: app.fontSourceRobotoBold.name
                    pixelSize: 14*app.scaleFactor
                    weight: Font.Bold
                }
                color: app.colorSecondary1
            }

            Rectangle {
                visible: listModelPlacesSorted.count > 0
                Layout.preferredWidth: lblSortType.contentWidth
                Layout.preferredHeight: lblSortType.contentHeight
                color: "transparent"

                Label {
                    id: lblSortType
                    Layout.alignment: Qt.AlignVCenter
                    text: app.sortBy
                    font {
                        family: app.fontSourceRobotoBold.name
                        pixelSize: 14*app.scaleFactor
                        weight: Font.Bold
                        underline: true
                    }
                    color: app.colorSecondary1
                }

                MouseArea {
                    anchors.fill: parent

                    onClicked: {
                        drawerOptions.open()
                    }
                }
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
                        dialogSortInfo.open()
                    }
                }
            }

            Item {
                Layout.fillWidth: true
            }
        }

        Item {
            Layout.preferredHeight: 12*app.scaleFactor
        }

        Rectangle {
            id: rectNoResults
            visible: featureTablePlaces.queryFeaturesStatus !== Enums.TaskStatusInProgress && listModelPlacesSorted.count === 0
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "transparent"

            Label {
                width: parent.width - (40*app.scaleFactor)
                text: "What a bummer! There were no activities found based on your selection criteria. Try changing your criteria to see results."
                horizontalAlignment: Text.AlignJustify
                font {
                    family: app.fontSourceRobotoBold.name
                    pixelSize: 16*app.scaleFactor
                    weight: Font.Bold
                }
                color: app.colorSecondary1
                anchors.centerIn: parent
                wrapMode: Text.WordWrap
            }
        }

        ListView {
            id: listView
            Layout.fillWidth: true
            Layout.fillHeight: true
            visible: !rectNoResults.visible
            topMargin: 8*app.scaleFactor
            bottomMargin: 12*app.scaleFactor
            spacing: 12*app.scaleFactor
            clip: true
            cacheBuffer: contentHeight > 0 ? contentHeight : 0
            model: listModelPlacesSorted
            delegate: ItemDelegate {
                id: paneCustomCard
                x: (listView.width - paneCustomCard.width)/2
                width: app.width >= 370*app.scaleFactor ? 360*app.scaleFactor : app.width - (30*app.scaleFactor)
                height: 112*app.scaleFactor
                Material.background: app.colorPrimary1
                Material.elevation: 4
                padding: 0

                background: Rectangle {
                    color: paneCustomCard.Material.backgroundColor
                    radius: 6
                    layer.enabled: true
                    layer.effect: ElevationEffect {
                        elevation: paneCustomCard.Material.elevation
                    }
                }

                RowLayout {
                    anchors.fill: parent
                    spacing: 0

                    Item {
                        Layout.preferredWidth: 8*app.scaleFactor
                    }

                    Image {
                        Layout.preferredWidth: 100*app.scaleFactor
                        Layout.preferredHeight: 88*app.scaleFactor
                        Layout.alignment: Qt.AlignVCenter
                        source: photoUrl
                        fillMode: Image.PreserveAspectCrop
                    }

                    Item {
                        Layout.preferredWidth: 8*app.scaleFactor
                    }

                    ColumnLayout {
                        Layout.fillHeight: true
                        spacing: 0

                        Item {
                            Layout.preferredHeight: 12*app.scaleFactor
                        }

                        Label {
                            Layout.fillWidth: true
                            text: name
                            color: app.colorSecondary1
                            font {
                                family: app.fontSourceRobotoBold.name
                                pixelSize: 16*app.scaleFactor
                                weight: Font.Bold
                            }
                            wrapMode: Text.WordWrap
                            maximumLineCount: 2
                            elide: Text.ElideMiddle
                        }

                        Item {
                            Layout.preferredHeight: 4*app.scaleFactor
                        }

                        RatingsComponent {
                            value: rating
                            totalValues: totalRatings
                            showRating: false
                        }

                        Item {
                            Layout.preferredHeight: 4*app.scaleFactor
                        }

                        Label {
                            text: distance.toString().replace(
                                      /(\d)(?=(?:\d{3})+(?:\.|$))|(\.\d\d?)\d*$/g,
                                      function(m, s1, s2){
                                          return s2 || (s1 + ',');
                                      }
                                      ) + " mi"
                            font {
                                family: app.fontSourceRobotoBold.name
                                pixelSize: 14*app.scaleFactor
                                weight: Font.Bold
                            }
                            color: app.colorSecondary1
                        }

                        Item {
                            Layout.fillHeight: true
                        }
                    }

                    Item {
                        Layout.preferredWidth: 8*app.scaleFactor
                    }
                }

                MouseArea {
                    anchors.fill: parent

                    onClicked: {
                        // Set place detail vars
                        _geomJson = geomJson
                        _placeId = placeId
                        _placeName = name
                        _photoUrl = photoUrl
                        _rating = rating
                        _totalRatings = totalRatings
                        _website = website
                        _phone = phone
                        _desc = desc
                        _address = address
                        _alwaysOpen = alwaysOpen
                        _sunOpen = sunOpen
                        _sunClose = sunClose
                        _monOpen = monOpen
                        _monClose = monClose
                        _tuesOpen = tuesOpen
                        _tuesClose = tuesClose
                        _wedOpen = wedOpen
                        _wedClose = wedClose
                        _thursOpen = thursOpen
                        _thursClose = thursClose
                        _friOpen = friOpen
                        _friClose = friClose
                        _satOpen = satOpen
                        _satClose = satClose
                        _arrHours = []
                        _favorite = favorite

                        getPlaceDetails()
                    }
                }

                Rectangle {
                    width: 25*app.scaleFactor
                    height: 25*app.scaleFactor
                    color: "transparent"
                    anchors {
                        right: parent.right
                        bottom: parent.bottom
                        margins: 12*app.scaleFactor
                    }

                    Image {
                        anchors.fill: parent
                        source: !favorite ? "assets/images/favorite.png" : "assets/images/favorite_fill.png"
                        mipmap: true
                    }

                    MouseArea {
                        anchors.fill: parent

                        onClicked: {
                            if (favorite) {
                                unlikePlace(placeId)
                                favorite = false
                            }else {
                                likePlace(placeId)
                                favorite = true
                            }
                        }
                    }
                }
            }
        }
    }

    BusyIndicator {
        anchors.centerIn: parent
        Material.accent: app.colorPrimary3
        running: featureTablePlaces.queryFeaturesStatus === Enums.TaskStatusInProgress
    }

    DialogInfo {
        id: dialogSortInfo
        labelText: app.sortDescObj[app.sortBy]
    }

    DialogInfo {
        id: dialogInfo
    }

    Drawer {
        id: drawerOptions
        width: parent.width
        height: app.isIos ? parent.height - (45*app.scaleFactor) : parent.height - (25*app.scaleFactor)
        edge: Qt.BottomEdge
        dragMargin: 0
        Material.background: app.colorPrimary2

        Rectangle {
            id: rectHeader
            width: parent.width
            height: 65*app.scaleFactor
            color: "transparent"

            ToolButton {
                id: btnClose
                visible: !txtFieldSearch.activeFocus
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
                    drawerOptions.close()
                }
            }

            ToolButton {
                id: btnBack
                visible: txtFieldSearch.activeFocus
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
            }
        }

        ColumnLayout {
            width: parent.width
            anchors.top: rectHeader.bottom
            spacing: 0

            Label {
                visible: !txtFieldSearch.activeFocus
                Layout.alignment: Qt.AlignHCenter
                text: "Options"
                font {
                    family: app.fontSourceRobotoBold.name
                    pixelSize: 24*app.scaleFactor
                    weight: Font.Bold
                }
                color: app.colorSecondary1
            }

            Item {
                Layout.preferredHeight: !txtFieldSearch.activeFocus ? 24*app.scaleFactor : 0
            }

            Label {
                visible: !txtFieldSearch.activeFocus
                Layout.leftMargin: 16*app.scaleFactor
                text: "Sort by:"
                font {
                    family: app.fontSourceRobotoBold.name
                    pixelSize: 16*app.scaleFactor
                    weight: Font.Bold
                }
                color: app.colorSecondary1
            }

            Item {
                Layout.preferredHeight: !txtFieldSearch.activeFocus ? 12*app.scaleFactor : 0
            }

            ButtonGroup {
                id: btnGroupSort
            }

            RadioButton {
                id: btnBestNearby
                visible: !txtFieldSearch.activeFocus
                Layout.leftMargin: 16*app.scaleFactor
                checked: true
                text: "Best nearby"
                ButtonGroup.group: btnGroupSort
                Material.background: app.colorPrimary1
                Material.accent: app.colorPrimary3
                Material.foreground: app.colorSecondary1
                spacing: 12*app.scaleFactor

                font {
                    family: app.fontSourceRobotoRegular.name
                    pixelSize: 14*app.scaleFactor
                    capitalization: Font.MixedCase
                }

                onCheckedChanged: {
                    if (checked) {
                        sortByLocal = "bestNearby"
                    }
                }
            }

            RadioButton {
                id: btnDistance
                visible: !txtFieldSearch.activeFocus
                Layout.leftMargin: 16*app.scaleFactor
                text: "Distance"
                ButtonGroup.group: btnGroupSort
                Material.background: app.colorSecondary1
                Material.accent: app.colorPrimary3
                Material.foreground: app.colorSecondary1
                spacing: 12*app.scaleFactor

                font {
                    family: app.fontSourceRobotoRegular.name
                    pixelSize: 14*app.scaleFactor
                    capitalization: Font.MixedCase
                }

                onCheckedChanged: {
                    if (checked) {
                        sortByLocal = "distance"
                    }
                }
            }

            RadioButton {
                id: btnRating
                visible: !txtFieldSearch.activeFocus
                Layout.leftMargin: 16*app.scaleFactor
                text: "Rating"
                ButtonGroup.group: btnGroupSort
                Material.background: app.colorPrimary1
                Material.accent: app.colorPrimary3
                Material.foreground: app.colorSecondary1
                spacing: 12*app.scaleFactor

                font {
                    family: app.fontSourceRobotoRegular.name
                    pixelSize: 14*app.scaleFactor
                    capitalization: Font.MixedCase
                }

                onCheckedChanged: {
                    if (checked) {
                        sortByLocal = "rating"
                    }
                }
            }

            Item {
                Layout.preferredHeight: !txtFieldSearch.activeFocus ? 32*app.scaleFactor : 0
            }

            Label {
                visible: !txtFieldSearch.activeFocus
                Layout.leftMargin: 16*app.scaleFactor
                text: "Display distances based on:"
                font {
                    family: app.fontSourceRobotoBold.name
                    pixelSize: 16*app.scaleFactor
                    weight: Font.Bold
                }
                color: app.colorSecondary1
            }

            Item {
                Layout.preferredHeight: !txtFieldSearch.activeFocus ? 12*app.scaleFactor : 0
            }

            ButtonGroup {
                id: btnGroupDistance
            }

            RadioButton {
                id: btnCurrentLocation
                visible: !txtFieldSearch.activeFocus
                Layout.leftMargin: 16*app.scaleFactor
                checked: true
                text: "My current location"
                ButtonGroup.group: btnGroupDistance
                Material.background: app.colorPrimary1
                Material.accent: app.colorPrimary3
                Material.foreground: app.colorSecondary1
                spacing: 12*app.scaleFactor

                font {
                    family: app.fontSourceRobotoRegular.name
                    pixelSize: 14*app.scaleFactor
                    capitalization: Font.MixedCase
                }

                onClicked: {
                    searchAddressLocal = "Address"
                }
            }

            RadioButton {
                id: btnAddress
                visible: !txtFieldSearch.activeFocus
                Layout.fillWidth: true
                Layout.leftMargin: 16*app.scaleFactor
                text: searchAddressLocal
                ButtonGroup.group: btnGroupDistance
                Material.background: app.colorSecondary1
                Material.accent: app.colorPrimary3
                Material.foreground: app.colorSecondary1
                spacing: 12*app.scaleFactor

                font {
                    family: app.fontSourceRobotoRegular.name
                    pixelSize: 14*app.scaleFactor
                    capitalization: Font.MixedCase
                }

                contentItem: Text {
                    width: btnAddress.indicator.width
                    text: btnAddress.text
                    font: btnAddress.font
                    wrapMode: Text.WordWrap
                    color: app.colorSecondary1
                    verticalAlignment: Text.AlignVCenter
                    leftPadding: btnAddress.indicator.width + btnAddress.spacing
                }
            }

            Item {
                Layout.preferredHeight: !txtFieldSearch.activeFocus ? 8*app.scaleFactor : 0
            }

            RowLayout {
                Layout.fillWidth: true
                visible: btnAddress.checked
                spacing: 0

                Item {
                    Layout.preferredWidth: 10.5*app.scaleFactor
                }

                Rectangle {
                    Layout.leftMargin: 12*app.scaleFactor
                    Layout.rightMargin: 24*app.scaleFactor
                    Layout.fillWidth: true
                    Layout.preferredHeight: 40*app.scaleFactor
                    color: app.colorPrimary1
                    radius: 20*app.scaleFactor

                    RowLayout {
                        anchors.fill: parent
                        spacing: 0

                        ToolButton {
                            Layout.preferredHeight: parent.height
                            opacity: 0.8
                            hoverEnabled: false
                            indicator: Image {
                                width: parent.width*0.6
                                height: parent.height*0.6
                                anchors.centerIn: parent
                                source: "assets/images/search.png" //isShowSearchBackground ? "assets/images/back.png" : "assets/images/search.png"
                                fillMode: Image.PreserveAspectFit
                                mipmap: true
                            }
                            onClicked: {
                                txtFieldSearch.clear()
                            }
                        }

                        TextField {
                            id: txtFieldSearch
                            Layout.fillWidth: true
                            Layout.preferredHeight: parent.height-(2*app.scaleFactor)
                            Layout.topMargin: 1*app.scaleFactor
                            Layout.bottomMargin: 1*app.scaleFactor
                            Material.accent: app.colorSecondary1
                            placeholderText: "Find address or place"
                            placeholderTextColor: app.colorSecondary1
                            focusReason: Qt.PopupFocusReason
                            bottomPadding: topPadding
                            inputMethodHints: Qt.ImhNoPredictiveText
                            font {
                                family: app.fontSourceRobotoRegular.name
                                pixelSize: 16*app.scaleFactor
                            }
                            color: app.colorSecondary1
                            background: Rectangle {
                                color: app.colorPrimary1
                                border.color: "transparent"
                                radius: 6*app.scaleFactor
                            }

                            onDisplayTextChanged: {
                                locatorTask.suggestions.searchText = txtFieldSearch.displayText
                            }

                            onActiveFocusChanged: {
                                console.log("activeFocus: " + activeFocus)
                                if (!activeFocus) {
                                    txtFieldSearch.clear()
                                    if (searchAddressLocal === "Address") {
                                        btnCurrentLocation.checked = true
                                        app.searchedAddress = "Address"
                                    }
                                }
                            }
                        }

                        ToolButton {
                            Layout.preferredHeight: parent.height
                            visible: txtFieldSearch.text > ""
                            opacity: 0.8
                            hoverEnabled: false
                            indicator: Image {
                                width: parent.width*0.6
                                height: parent.height*0.6
                                anchors.centerIn: parent
                                source: "assets/images/close.png"
                                fillMode: Image.PreserveAspectFit
                                mipmap: true
                            }
                            onClicked: {
                                txtFieldSearch.forceActiveFocus()
                                txtFieldSearch.clear()
                            }
                        }
                    }
                }

                Item {
                    Layout.preferredWidth: 10.5*app.scaleFactor
                }
            }

            Item {
                Layout.preferredHeight: txtFieldSearch.activeFocus ? 8*app.scaleFactor : 0
            }

            ListView {
                id: listViewAddresses
                visible: txtFieldSearch.activeFocus
                Layout.fillWidth: true
                Layout.preferredHeight: drawerOptions.height - 80*app.scaleFactor
                clip: true
                spacing: 0
                model: locatorTask.suggestions
                delegate: ItemDelegate {
                    width: listViewAddresses.width
                    height: 60*app.scaleFactor
                    text: locatorTask.suggestions && locatorTask.suggestions.get(index)? locatorTask.suggestions.get(index).label : ""
                    font {
                        family: app.fontSourceRobotoBold.name
                        pixelSize: 14*app.scaleFactor
                        weight: Font.Bold
                    }
                    Material.background: app.colorPrimary1
                    Material.foreground: app.colorSecondary1

                    onClicked: {
                        geocodeAddress(locatorTask.suggestions.get(index).label)
                    }
                }
            }
        }

        onClosed: {
            if (app.sortBy !== sortByLocal) {
                app.sortBy = sortByLocal

                if (app.sortBy === "bestNearby") {
                    sortModel(arrBestNearby, listModelPlaces, listModelPlacesSorted, "placeId", "bestNearby", true)
                }else if (app.sortBy === "distance") {
                    sortModel(arrDistance, listModelPlaces, listModelPlacesSorted, "placeId", "distance", false)
                }else if (app.sortBy === "rating") {
                    sortModel(arrRating, listModelPlaces, listModelPlacesSorted, "placeId", "rating", true)
                }

                listView.contentY = 0

            }

            if (app.searchedAddress !== searchAddressLocal) {
                app.searchedAddress = searchAddressLocal
                queryPlaces()
            }
        }

        BusyIndicator {
            anchors.centerIn: parent
            Material.accent: app.colorPrimary3
            running: locatorTask.geocodeStatus === Enums.TaskStatusInProgress
        }
    }

    GeocodeParameters {
        id: geocodeParameters
        minScore: 75
        maxResults: 10
        countryCode: "US"
        preferredSearchLocation: currentLocation
        resultAttributeNames: ["Place_addr", "Match_addr", "Postal", "Region"]
    }

    LocatorTask {
        id: locatorTask
        url: app.locatorUrl
        suggestions.suggestParameters: SuggestParameters{
            maxResults: 10
            preferredSearchLocation: currentLocation
            countryCode: "US"
        }
        suggestions.searchText: txtFieldSearch.text
        onGeocodeStatusChanged: {
            if (geocodeStatus === Enums.TaskStatusCompleted) {
                if(geocodeResults.length > 0) {
                    for(var i in geocodeResults) {
                        var e = geocodeResults[i]
                        var point = e.displayLocation;
                        app.searchedAddressPoint = GeometryEngine.project(point, srWGS84)
                        searchAddressLocal = e.attributes.Place_addr
                        listViewAddresses.forceActiveFocus()
                        txtFieldSearch.clear()
                        break
                    }
                }
            }
        }
    }

    function geocodeAddress(address) {
        if(currentLocatorTaskId > "" && locatorTask.loadStatus === Enums.LoadStatusLoading) locatorTask.cancelTask(currentLocatorTaskId)
        currentLocatorTaskId = locatorTask.geocodeWithParameters(address, geocodeParameters)
    }
}
