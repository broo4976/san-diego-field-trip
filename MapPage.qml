import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Controls.Material 2.3
import QtQuick.Controls.Material.impl 2.12
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

import QtPositioning 5.12

import Esri.ArcGISRuntime 100.10

Page {

    Material.background: app.colorPrimary2

    // Map properties
    property FeatureLayer featureLayerPlaces: null
    property ServiceFeatureTable featureTablePlaces: null

    Component.onCompleted: {
        mapView.locationDisplay.start()
    }

    MapView {
        id: mapView
        anchors.fill: parent
        attributionTextVisible: false

        locationDisplay {
            positionSource: positionSource
        }

        SelectionProperties {
            color: app.colorSecondary2
        }

        Map {
            id: map
            initUrl: app.webMapUrl

            onOperationalLayersChanged: {
                for (var i = 0; i < operationalLayers.count; i++) {
                    var layer = operationalLayers.get(i)
                    if (layer.name === app.placesLayerName) {
                        featureLayerPlaces = layer
                        featureTablePlaces = featureLayerPlaces.featureTable
                    }
                }
            }
        }

        onMouseClicked: {
            listModelPlacesMap.clear()
            identifyLayerWithMaxResults(featureLayerPlaces, mouse.x, mouse.y, 15*app.scaleFactor, false, 20)
        }

        onIdentifyLayerStatusChanged: {
            if (identifyLayerStatus === Enums.TaskStatusCompleted) {
                var userLon
                var userLat
                if (Qt.platform.os !== "windows") {
                    userLon = positionSource.position.coordinate.longitude
                    userLat = positionSource.position.coordinate.latitude
                }else {
                    userLon = homePage.positionSource.position.coordinate.longitude
                    userLat = homePage.positionSource.position.coordinate.latitude
                }


                var userLocation = ArcGISRuntimeEnvironment.createObject("Point", {x: userLon, y: userLat, spatialReference: srWGS84})
                var userLocationMeters = GeometryEngine.project(userLocation, srWebMercator)

                for (var i = 0; i < identifyLayerResult.geoElements.length; i++) {
                    var feature = identifyLayerResult.geoElements[i]
                    var attributes = feature.attributes
                    var geometry = feature.geometry

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

                    // Rank "best nearby" based on formula:
                    var bestNearby = ((rating*1) + (totalRatings*0.008) + (distanceMiles*-1)) * -1


                    listModelPlacesMap.append({"name": name, "placeId": placeId, "desc": desc, "photoUrl": photoUrl,
                                               "address": address, "phone": phone, "website": website, "rating": rating,
                                               "totalRatings": totalRatings, "alwaysOpen": alwaysOpen, "sunOpen": sunOpen,
                                               "sunClose": sunClose, "monOpen": monOpen, "monClose": monClose, "tuesOpen": tuesOpen,
                                               "tuesClose": tuesClose, "wedOpen": wedOpen, "wedClose": wedClose,
                                               "thursOpen": thursOpen, "thursClose": thursClose, "friOpen": friOpen,
                                               "friClose": friClose, "satOpen": satOpen, "satClose": satClose,
                                               "distance": distanceMiles, "bestNearby": bestNearby, "geomJson": geometry.json,
                                               "favorite": favorite})
                }


            }
        }

        ListView {
            id: listView
            width: parent.width
            height: 148*app.scaleFactor
            clip: true
            orientation: ListView.Horizontal
            snapMode: ListView.SnapOneItem
            spacing: 20*app.scaleFactor
            model: listModelPlacesMap
            anchors {
                left: parent.left
                leftMargin: 12*app.scaleFactor
                bottom: parent.bottom
            }

            Connections {
                target: listView.model

                function onCountChanged() {
                    if (listView.model.count > 0) {
                        selectAndZoomToFeature(0)
                    }
                }
            }

            onFlickEnded: {
                featureLayerPlaces.clearSelection()
                currentIndex = indexAt(contentX, contentY)

                selectAndZoomToFeature(currentIndex)

            }

            footer: Rectangle {
                width: listView.width - (302*app.scaleFactor)
                height: parent.height
                color: "transparent"
            }

            delegate: Pane {
                id: paneCustomCard
                width: 302*app.scaleFactor
                height: 148*app.scaleFactor
                Material.background: app.colorPrimary1
                Material.elevation: 2
                padding: 0

                background: Rectangle {
                    color: paneCustomCard.Material.backgroundColor
                    radius: 6
                    layer.enabled: true
                    layer.effect: ElevationEffect {
                        elevation: paneCustomCard.Material.elevation
                    }
                    border {
                        width: 2*app.scaleFactor
                        color: app.colorPrimary3
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

                ColumnLayout {
                    anchors.fill: parent
                    spacing: 0

                    Item {
                        Layout.preferredHeight: 12*app.scaleFactor
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 0

                        Item {
                            Layout.preferredWidth: 12*app.scaleFactor
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
                            elide: Text.ElideMiddle
                        }

                        Item {
                            Layout.preferredWidth: 12*app.scaleFactor
                        }
                    }

                    Item {
                        Layout.preferredHeight: 4*app.scaleFactor
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 0

                        Item {
                            Layout.preferredWidth: 12*app.scaleFactor
                        }

                        ColumnLayout {
                            spacing: 0

                            RowLayout {
                                spacing: 3

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
                                        position: (rating % 1).toFixed(1) <= 0.5 ? 1-(rating % 1).toFixed(1) : 0.5
                                        color: app.colorPrimary3
                                    }
                                    GradientStop {
                                        position: (rating % 1).toFixed(1) >= 0.5 ? 1-(rating % 1).toFixed(1) : 0.5
                                        color: app.colorPrimary1
                                    }
                                }

                                Gradient {
                                    id: gradient3
                                    GradientStop {
                                        position: 1
                                        color: app.colorPrimary1
                                    }
                                }

                                Repeater {
                                    model: [1,2,3,4,5]

                                    Rectangle {
                                        width: 9*app.scaleFactor
                                        height: 9*app.scaleFactor
                                        radius: 10
                                        color: modelData <= Math.floor(rating) ? app.colorPrimary3 : app.colorPrimary1
                                        rotation: 90
                                        gradient: modelData > 0 ? (modelData <= Math.floor(rating) ? gradient1 : (modelData > Math.floor(rating) + 1 ? gradient3 : gradient2)) : ""

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
                                    text: totalRatings.toString().replace(
                                              /(\d)(?=(?:\d{3})+(?:\.|$))|(\.\d\d?)\d*$/g,
                                              function(m, s1, s2){
                                                  return s2 || (s1 + ',');
                                              }
                                              )
                                    font {
                                        family: app.fontSourceRobotoBold.name
                                        pixelSize: 14*app.scaleFactor
                                        weight: Font.Bold
                                    }
                                    color: app.colorPrimary3
                                }
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

                            Rectangle {
                                Layout.preferredWidth: 25*app.scaleFactor
                                Layout.preferredHeight: 25*app.scaleFactor
                                color: "transparent"

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

                                        // Update in list view model
                                        for (var i = 0; i < listModelPlacesSorted.count; i++) {
                                            if (listModelPlacesSorted.get(i).placeId === placeId) {
                                                listModelPlacesSorted.get(i).favorite = favorite
                                                break
                                            }
                                        }
                                    }
                                }
                            }

                            Item {
                                Layout.preferredHeight: 12*app.scaleFactor
                            }
                        }

                        Item {
                            Layout.fillWidth: true
                        }

                        ColumnLayout {
                            spacing: 0

                            Image {
                                Layout.preferredWidth: 138*app.scaleFactor
                                Layout.preferredHeight: 99*app.scaleFactor
                                Layout.alignment: Qt.AlignVCenter
                                source: photoUrl
                                fillMode: Image.PreserveAspectCrop
                            }

                            Item {
                                Layout.preferredHeight: 12*app.scaleFactor
                            }
                        }

                        Item {
                            Layout.preferredWidth: 16*app.scaleFactor
                        }
                    }
                }
            }
        }
    }

    PositionSource {
        id: positionSource
    }

    SpatialReference {
        id: srWGS84
        wkid: 4326
    }

    SpatialReference {
        id: srWebMercator
        wkid: 102100
    }

    QueryParameters {
        id: queryParamsSelect
    }

    QueryParameters {
        id: queryParamsZoom
        whereClause: "1=1"
    }

    Connections {
        target: featureTablePlaces

        function onQueryFeaturesStatusChanged() {
            if (featureTablePlaces.queryFeaturesStatus === Enums.TaskStatusCompleted) {
                var arrGeom = []
                while (featureTablePlaces.queryFeaturesResult.iterator.hasNext) {
                    var feature = featureTablePlaces.queryFeaturesResult.iterator.next()
                    var geometry = feature.geometry
                    arrGeom.push(geometry)
                }

                var combinedExtent = GeometryEngine.combineExtentsOfGeometries(arrGeom)
                mapView.setViewpointGeometryAndPadding(combinedExtent.extent, 50*app.scaleFactor)

            }
        }
    }

    function selectAndZoomToFeature(index) {
        featureLayerPlaces.clearSelection()
        var placeId = listModelPlacesMap.get(index).placeId
        queryParamsSelect.whereClause = app.fldPlaceId + " = '" + placeId + "'"
        featureLayerPlaces.selectFeaturesWithQuery(queryParamsSelect, Enums.SelectionModeNew)

        var geomJson = listModelPlacesMap.get(index).geomJson
        var point = ArcGISRuntimeEnvironment.createObject("Point", {x: geomJson.x, y: geomJson.y, spatialReference: srWebMercator})
        mapView.setViewpointCenterAndScale(point, 30000)
    }

    function selectAndZoomToFeatureFromPlaceDetails(placeId, geomJson) {
        featureLayerPlaces.clearSelection()
        queryParamsSelect.whereClause = app.fldPlaceId + " = '" + placeId + "'"
        featureLayerPlaces.selectFeaturesWithQuery(queryParamsSelect, Enums.SelectionModeNew)

        var point = ArcGISRuntimeEnvironment.createObject("Point", {x: geomJson.x, y: geomJson.y, spatialReference: srWebMercator})
        mapView.setViewpointCenterAndScale(point, 30000)
    }

    function zoomToResults() {
        featureLayerPlaces.clearSelection()
        featureTablePlaces.queryFeaturesWithFieldOptions(queryParamsZoom, Enums.QueryFeatureFieldsLoadAll)
        //mapView.setViewpointGeometryAndPadding(featureLayerPlaces.fullExtent, 100*app.scaleFactor)
    }

    footer: Rectangle{
        width: parent.width
        height: app.isIos ? (app.hasNotch ? 70*app.scaleFactor : 40*app.scaleFactor) : 0*app.scaleFactor
        color: app.colorPrimary2
    }
}
