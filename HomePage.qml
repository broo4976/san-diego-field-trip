import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Controls.Material 2.3
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

import QtPositioning 5.12

import Esri.ArcGISRuntime 100.10


Page {
    Material.background: app.colorPrimary2

    // Places service
    property ServiceFeatureTable featureTablePlaces: null
    property FeatureLayer featureLayerPlaces: null
    // Reviews service
    property ServiceFeatureTable featureTableReviews: null


    // Current location point
    property Point currentLocation: null

    // Selected place vars
    property string _placeName: ""
    property string _placeId: ""
    property string _photoUrl: ""
    property double _rating: 0.0
    property int _totalRatings: 0
    property string _website: ""
    property string _phone: ""
    property bool _alwaysOpen: false
    property bool _openNow: false
    property int _todayIndex: 0
    property var _arrHours: []
    property string _sunOpen: ""
    property string _sunClose: ""
    property string _monOpen: ""
    property string _monClose: ""
    property string _tuesOpen: ""
    property string _tuesClose: ""
    property string _wedOpen: ""
    property string _wedClose: ""
    property string _thursOpen: ""
    property string _thursClose: ""
    property string _friOpen: ""
    property string _friClose: ""
    property string _satOpen: ""
    property string _satClose: ""
    property string _desc: ""
    property string _address: ""
    property var _geomJson
    property bool _favorite

    // Map list model
    property alias listModelPlacesMap: listModelPlacesMap
    ListModel {
        id: listModelPlacesMap
    }

    // Results list model
    property alias listModelPlaces: listModelPlaces
    ListModel {
        id: listModelPlaces
    }

    property alias listModelPlacesSorted: listModelPlacesSorted
    ListModel {
        id: listModelPlacesSorted
    }

    // Reviews list model
    property alias listModelReviews: listModelReviews
    ListModel {
        id: listModelReviews
    }
    property alias listModelReviewsSorted: listModelReviewsSorted
    ListModel {
        id: listModelReviewsSorted
    }

    // Sort arrays
    property var arrBestNearby: []
    property var arrDistance: []
    property var arrRating:[]

    // Aliases
    property alias swipeView: swipeView
    property alias positionSource: positionSource

    Component.onCompleted: {
        positionSource.start()

        featureTablePlaces = ArcGISRuntimeEnvironment.createObject("ServiceFeatureTable", {url: app.placesLayerUrl})
        featureTablePlaces.load()

        featureTableReviews = ArcGISRuntimeEnvironment.createObject("ServiceFeatureTable", {url: app.reviewsTableUrl})
        featureTableReviews.load()
    }

    Keys.onReleased: {
        if (event.key === Qt.Key_Back || event.key === Qt.Key_Escape){
            event.accepted = true
            if (swipeView.currentIndex > 0) {
                swipeView.currentIndex -= 1
            }
        }
    }

    Rectangle {
        anchors.fill: parent
        color: app.colorPrimary2

        Rectangle {
            id: rectHeader
            width: parent.width
            height: 65*app.scaleFactor
            anchors.top: parent.top
            color: "transparent"

            ToolButton {
                id: btnBack
                visible: swipeView.currentIndex > 0
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
                    if (swipeView.currentIndex === 3) {
                        featureLayerPlaces.definitionExpression = app.filterMaster
                    }

                    // If coming from map page, clear map list model and re-open details page
                    if (app.mapFromPlaceDetails) {
                        listModelPlacesMap.clear()
                        app.mapFromPlaceDetails = false
                        app.stackView.push(placeDetailsPage)
                    }

                    // Go back
                    swipeView.currentIndex -= 1
                }
            }

            Rectangle {
                id: rectDetails
                visible: swipeView.currentIndex > 2
                width: parent.width - (btnBack.width*2) - (20*app.scaleFactor)
                height: 40*app.scaleFactor
                color: "transparent"
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    verticalCenter: btnBack.verticalCenter
                }

                Label {
                    anchors.fill: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    text: (swipeView.currentIndex === swipeView.count-1 && app.mapFromPlaceDetails) ? _placeName : app.who + " - " + app.active + " - " + app.where
                    wrapMode: Text.WordWrap
                    font {
                        family: app.fontSourceRobotoBold.name
                        pixelSize: 16*app.scaleFactor
                        weight: Font.Bold
                    }
                    color: app.colorSecondary1
                }
            }
        }

        SwipeView {
            id: swipeView
            currentIndex: 0
            width: parent.width
            height: swipeView.currentIndex <= 2 ? parent.height - (pageIndicator.height + rectHeader.height) : parent.height - rectHeader.height
            anchors.top: rectHeader.bottom
            interactive: false

            QuestionWhoAreYouWith {}

            QuestionHowDoYouFeel {}

            QuestionWhereDoYouWantToBe {}

            ListPage {
                onMapButtonClicked: {
                    listModelPlacesMap.clear()
                    swipeView.currentIndex += 1
                    mapPage.zoomToResults()
                }
            }

            MapPage {
                id: mapPage
            }
        }

        PageIndicator {
            id: pageIndicator
            visible: currentIndex <= 2
            count: swipeView.count-2
            currentIndex: swipeView.currentIndex
            interactive: false
            spacing: 25*app.scaleFactor

            delegate: Rectangle {
                width: 18*app.scaleFactor
                height: width
                radius: 18
                color: app.colorPrimary3
                opacity: index === pageIndicator.currentIndex ? 1 : 0.4
            }

            anchors {
                bottom: parent.bottom
                bottomMargin: 10*app.scaleFactor
                horizontalCenter: parent.horizontalCenter
            }
        }

    }

    PositionSource {
        id: positionSource
    }


    QueryParameters {
        id: queryParamsPlaces
        returnGeometry: true
    }

    QueryParameters {
        id: queryParamsReviews
    }

    SpatialReference {
        id: srWGS84
        wkid: 4326
    }

    SpatialReference {
        id: srWebMercator
        wkid: 102100
    }

    Component {
        id: placeDetailsPage

        PlaceDetailsPage {}
    }

    Connections {
        target: featureTablePlaces

        function onLoadStatusChanged() {
            if (featureTablePlaces.loadStatus === Enums.LoadStatusLoaded) {
                featureLayerPlaces = ArcGISRuntimeEnvironment.createObject("FeatureLayer", {featureTable: featureTablePlaces})
            }
        }

        function onQueryFeaturesStatusChanged() {
            if (featureTablePlaces.queryFeaturesStatus === Enums.TaskStatusCompleted) {

                var userLocationMeters
                if (app.searchedAddress === "Address") {
                    var userLon = positionSource.position.coordinate.longitude
                    var userLat = positionSource.position.coordinate.latitude
                    currentLocation = ArcGISRuntimeEnvironment.createObject("Point", {x: userLon, y: userLat, spatialReference: srWGS84})
                    userLocationMeters = GeometryEngine.project(currentLocation, srWebMercator)
                }else {
                    userLocationMeters = GeometryEngine.project(app.searchedAddressPoint, srWebMercator)
                }

                arrBestNearby = []
                arrDistance = []
                arrRating = []

                while (featureTablePlaces.queryFeaturesResult.iterator.hasNext) {
                    var feature = featureTablePlaces.queryFeaturesResult.iterator.next()
                    var geometry = feature.geometry
                    var attributes = feature.attributes
                    var name = attributes.attributeValue(app.fldPlaceName) ? attributes.attributeValue(app.fldPlaceName) : ""
                    var placeId = attributes.attributeValue(app.fldPlaceId)
                    var desc = attributes.attributeValue(app.fldDesc) ? attributes.attributeValue(app.fldDesc) : ""
                    var photoUrl = attributes.attributeValue(app.fldPhotoUrl) ? attributes.attributeValue(app.fldPhotoUrl) : ""
                    var address = attributes.attributeValue(app.fldAddress) ? attributes.attributeValue(app.fldAddress) : ""
                    var phone = attributes.attributeValue(app.fldPhone) ? attributes.attributeValue(app.fldPhone) : ""
                    var website = attributes.attributeValue(app.fldWebsite) ? attributes.attributeValue(app.fldWebsite) : ""
                    var rating = attributes.attributeValue(app.fldRating) !== "None" ? attributes.attributeValue(app.fldRating) : "0"
                    var totalRatings = attributes.attributeValue(app.fldTotalRatings) !== "None" ? attributes.attributeValue(app.fldTotalRatings) : "0"
                    var alwaysOpen = attributes.attributeValue(app.fldAlwaysOpen) === 1 ? true : false
                    var sunOpen = attributes.attributeValue(app.fldSunOpen) ? attributes.attributeValue(app.fldSunOpen) : ""
                    var sunClose = attributes.attributeValue(app.fldSunClose) ? attributes.attributeValue(app.fldSunClose) : ""
                    var monOpen = attributes.attributeValue(app.fldMonOpen) ? attributes.attributeValue(app.fldMonOpen) : ""
                    var monClose = attributes.attributeValue(app.fldMonClose) ? attributes.attributeValue(app.fldMonClose) : ""
                    var tuesOpen = attributes.attributeValue(app.fldTuesOpen) ? attributes.attributeValue(app.fldTuesOpen) : ""
                    var tuesClose = attributes.attributeValue(app.fldTuesClose) ? attributes.attributeValue(app.fldTuesClose) : ""
                    var wedOpen = attributes.attributeValue(app.fldWedOpen) ? attributes.attributeValue(app.fldWedOpen) : ""
                    var wedClose = attributes.attributeValue(app.fldWedClose) ? attributes.attributeValue(app.fldWedClose) : ""
                    var thursOpen = attributes.attributeValue(app.fldThursOpen) ? attributes.attributeValue(app.fldThursOpen) : ""
                    var thursClose = attributes.attributeValue(app.fldThursClose) ? attributes.attributeValue(app.fldThursClose) : ""
                    var friOpen = attributes.attributeValue(app.fldFriOpen) ? attributes.attributeValue(app.fldFriOpen) : ""
                    var friClose = attributes.attributeValue(app.fldFriClose) ? attributes.attributeValue(app.fldFriClose) : ""
                    var satOpen = attributes.attributeValue(app.fldSatOpen) ? attributes.attributeValue(app.fldSatOpen) : ""
                    var satClose = attributes.attributeValue(app.fldSatClose) ? attributes.attributeValue(app.fldSatClose) : ""

                    var favorite = app.arrFavorites.indexOf(placeId) > -1

                    var distance = GeometryEngine.distance(userLocationMeters, geometry)
                    var distanceMiles = (distance * app.metersToMiles).toFixed(1)

                    // Ranking
                    var distanceRank
                    var ratingRank
                    var totalRatingsRank

                    if (distanceMiles < 1) {
                        distanceRank = 5
                    }else if (distanceMiles < 2) {
                        distanceRank = 4
                    }else if (distanceMiles < 5) {
                        distanceRank = 3
                    }else if (distanceMiles < 10) {
                        distanceRank = 2
                    }else {
                        distanceRank = 1
                    }

                    ratingRank = Math.round(rating)

                    if (totalRatings > 100) {
                        totalRatingsRank = 5
                    }else if (totalRatings > 50) {
                        totalRatingsRank = 4
                    }else if (totalRatings > 30) {
                        totalRatingsRank = 3
                    }else if (totalRatings > 10) {
                        totalRatingsRank = 2
                    }else {
                        totalRatingsRank = 1
                    }

                    // Rank "best nearby" based on formula:
                    var bestNearby = (distanceRank*0.5) + (ratingRank*0.35) + (totalRatingsRank*0.15)

                    arrBestNearby.push(bestNearby)
                    arrDistance.push(distanceMiles)
                    arrRating.push(rating)


                    listModelPlaces.append({"name": name, "placeId": placeId, "desc": desc, "photoUrl": photoUrl,
                                               "address": address, "phone": phone, "website": website, "rating": rating,
                                               "totalRatings": totalRatings, "alwaysOpen": alwaysOpen, "sunOpen": sunOpen,
                                               "sunClose": sunClose, "monOpen": monOpen, "monClose": monClose, "tuesOpen": tuesOpen,
                                               "tuesClose": tuesClose, "wedOpen": wedOpen, "wedClose": wedClose,
                                               "thursOpen": thursOpen, "thursClose": thursClose, "friOpen": friOpen,
                                               "friClose": friClose, "satOpen": satOpen, "satClose": satClose,
                                               "distance": distanceMiles, "bestNearby": bestNearby, "geomJson": geometry.json,
                                               "favorite": favorite})
                }

                var arrSort = []
                if (app.sortBy === "bestNearby") {
                    arrSort = arrBestNearby
                }else if (app.sortBy === "distance") {
                    arrSort = arrDistance
                }else {
                    arrSort = arrRating
                }

                sortModel(arrSort, listModelPlaces, listModelPlacesSorted, "placeId", app.sortBy, app.sortReverseObj[app.sortBy])
            }
        }
    }

    Connections {
        target: featureTableReviews

        function onQueryFeaturesStatusChanged() {
            if (featureTableReviews.queryFeaturesStatus === Enums.TaskStatusCompleted) {
                var arrReviewTimes = []
                while (featureTableReviews.queryFeaturesResult.iterator.hasNext) {
                    var feature = featureTableReviews.queryFeaturesResult.iterator.next()
                    var attributes = feature.attributes
                    var author = attributes.attributeValue(app.fldAuthor) ? attributes.attributeValue(app.fldAuthor) : ""
                    var authorPhoto = attributes.attributeValue(app.fldAuthorPhoto) ? attributes.attributeValue(app.fldAuthorPhoto) : ""
                    var userRating = attributes.attributeValue(app.fldRating) ? attributes.attributeValue(app.fldRating) : ""
                    var relTime = attributes.attributeValue(app.fldRelTime) ? attributes.attributeValue(app.fldRelTime) : ""
                    var review = attributes.attributeValue(app.fldReview) ? attributes.attributeValue(app.fldReview) : ""
                    var reviewTimeUnix = attributes.attributeValue(app.fldReviewTime)
                    var reviewTime = timestampToDateString(reviewTimeUnix)

                    arrReviewTimes.push(reviewTimeUnix)

                    listModelReviews.append({"placeId": _placeId, "author": author, "authorPhoto": authorPhoto, "userRating": userRating,
                                                "review": review, "reviewTime": reviewTime, "reviewTimeUnix": reviewTimeUnix})
                }

                arrReviewTimes.sort()
                sortReviewTimes(arrReviewTimes, listModelReviews, listModelReviewsSorted, "reviewTimeUnix")
            }
        }
    }

    function unlikePlace(id) {
        app.dbFunctions.deleteFavorite(id)
        app.arrFavorites = app.dbFunctions.getFavorites()
    }

    function likePlace(id) {
        app.dbFunctions.saveFavorite(id)
        app.arrFavorites = app.dbFunctions.getFavorites()
    }

    function sortReviewTimes(sortArr, listModel, listModelSorted, id) {
        // Clear list model
        listModelSorted.clear()

        // Loop through array of records and add items to sorted model
        for (var i = 0; i < sortArr.length; i++) {
            for (var j = 0; j < listModel.count; j++) {
                if (sortArr[i] === listModel.get(j)[id]) {
                    listModelSorted.insert(0, listModel.get(j))
                }
            }
        }
    }

    function sortModel(sortArr, listModel, listModelSorted, id, attribute, reverse=false) {
        // Clear model
        listModelSorted.clear()

        // Array to store ids to ensure duplicate records are not presented due to duplicate times
        var idArr = []

        // Sort distances array
        if (attribute === "distance") {
            sortArr.sort(function(a, b){return a-b})
        }else {
            sortArr.sort()
        }

        if (reverse) {
            sortArr.reverse()
        }

        // Loop through array of values and add items to sorted model
        for (var i = 0; i < sortArr.length; i++) {
            for (var j = 0; j < listModel.count; j++) {
                if (sortArr[i] === listModel.get(j)[attribute]) {
                    if (idArr.indexOf(listModel.get(j)[id]) === -1) {
                        listModelSorted.append(listModel.get(j))
                        idArr.push(listModel.get(j)[id])
                    }
                }
            }
        }
    }

    function queryPlaces() {
        listModelPlaces.clear()
        listModelPlacesSorted.clear()
        queryParamsPlaces.whereClause = app.filterMaster
        console.log(app.filterMaster)
        featureTablePlaces.queryFeaturesWithFieldOptions(queryParamsPlaces, Enums.QueryFeatureFieldsLoadAll)
    }

    function getResults() {
        mapPage.featureLayerPlaces.definitionExpression = app.filterMaster
        queryPlaces()
        swipeView.currentIndex += 1
    }

    function getPlaceDetails() {
        // Get current date/time
        var currentTime = new Date()
        var day = currentTime.getDay()
        var hoursObj = ({0: {"open": _sunOpen, "close": _sunClose}, 1: {"open": _monOpen, "close": _monClose},
                           2: {"open": _tuesOpen, "close": _tuesClose}, 3: {"open": _wedOpen, "close": _wedClose},
                           4: {"open": _thursOpen, "close": _thursClose}, 5: {"open": _friOpen, "close": _friClose},
                           6: {"open": _satOpen, "close": _satClose}})


        // Check if open
        if (_alwaysOpen) {
            _openNow = true

        }else {
            if (day === 0) {
                if (_sunOpen === "None") {
                    _openNow = false
                }else {
                    _openNow = isOpen(currentTime, _sunOpen, _sunClose)
                }
            }else if (day === 1) {
                if (_monOpen === "None") {
                    _openNow = false
                }else {
                    _openNow = isOpen(currentTime, _monOpen, _monClose)
                }
            }else if (day === 2) {
                if (_tuesOpen === "None") {
                    _openNow = false
                }else {
                    _openNow = isOpen(currentTime, _tuesOpen, _tuesClose)
                }
            }else if (day === 3) {
                if (_wedOpen === "None") {
                    _openNow = false
                }else {
                    _openNow = isOpen(currentTime, _wedOpen, _wedClose)
                }
            }else if (day === 4) {
                if (_thursOpen === "None") {
                    _openNow = false
                }else {
                    _openNow = isOpen(currentTime, _thursOpen, _thursClose)
                }
            }else if (day === 5) {
                if (_friOpen === "None") {
                    _openNow = false
                }else {
                    _openNow = isOpen(currentTime, _friOpen, _friClose)
                }
            }else {
                if (_satOpen === "None") {
                    _openNow = false
                }else {
                    _openNow = isOpen(currentTime, _satOpen, _satClose)
                }
            }
        }

        var time
        // Get Mon-Sat
        for (var i = 1; i <= 6; i++) {
            if (_alwaysOpen) {
                time = "Open 24 hours"
            }else if (hoursObj[i].open === "None") {
                time = "Closed"
            }else {
                time = parseHours(hoursObj[i].open) + " - " + parseHours(hoursObj[i].close)
            }
            _arrHours.push({"day": app.daysObj[i], "time": time, "currentDay": i === day})
            if (i === day) {
                _todayIndex = i-1
            }
        }

        // Get Sun
        if (hoursObj[0].open === "None") {
            time = "Closed"
        }else if (_alwaysOpen) {
            time = "Open 24 hours"
        }else {
            time = parseHours(hoursObj[0].open) + " - " + parseHours(hoursObj[0].close)
        }
        _arrHours.push({"day": app.daysObj[0], "time": time, "currentDay": 0 === day})
        if (0 === day) {
            _todayIndex = 6
        }

        // Get reviews
        listModelReviews.clear()
        listModelReviewsSorted.clear()
        queryParamsReviews.whereClause = app.fldPlaceId + " = '" + _placeId + "'"
        featureTableReviews.queryFeaturesWithFieldOptions(queryParamsReviews, Enums.QueryFeatureFieldsLoadAll)

        // Open place details
        app.stackView.push(placeDetailsPage)
    }

    function timestampToDateString(timestamp) {
        var date = new Date(timestamp*1000)
        var dateStr = app.monthsObj[date.getMonth()] + " " + date.getDate() + ", " + date.getFullYear()
       return dateStr
    }

    function parseHours(time) {
        var hours = time.slice(0, -2)
        var minutes = time.slice(-2)
        var hoursInt = parseInt(hours)

        var ampm = ""
        var newTime = ""

        if (hoursInt >= 12) {
            ampm = "PM"
            if (hoursInt > 12) {
                hours = 12 - (24 - hoursInt)
            }
        }else {
            ampm = "AM"
            if (parseInt(time) === 0) {
                hours = "12"
                minutes = "00"
            }
        }
        newTime = hours + ":" + minutes + " " + ampm

        return newTime
    }

    function isOpen(currentTime, open, close) {
        var hour = currentTime.getHours()
        var minute = currentTime.getMinutes()
        var timeStr = ("0" + hour.toString()).slice(-2) + ("0" + minute.toString()).slice(-2)

        return parseInt(timeStr) > parseInt(open) && parseInt(timeStr) < parseInt(close)
    }

}

