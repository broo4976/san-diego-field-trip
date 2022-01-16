import QtQuick 2.13
import QtQuick.Controls 2.13
import ArcGIS.AppFramework.Networking 1.0
import ArcGIS.AppFramework.Platform 1.0

import ArcGIS.AppFramework 1.0
import Esri.ArcGISRuntime 100.10


AppLayout {
    id: appLayout
    width: 400
    height: 640
    delegate: App {
        id: app
        width: appLayout.width
        height: appLayout.height

        // Display scale factor
        property real scaleFactor: AppFramework.displayScaleFactor

        // Web map
        property string webMapUrl: "https://ps-dbs.maps.arcgis.com/home/webmap/viewer.html?webmap=8289c205a2244f4ea537405d509df7a0"
        // Map layers
        property string placesLayerName: "Places"
        property string placesLayerUrl: "https://services1.arcgis.com/g2TonOxuRkIqSOFx/arcgis/rest/services/San_Diego_Field_Trip_WFL1/FeatureServer/0"
        // Reviews table
        property string reviewsTableUrl: "https://services1.arcgis.com/g2TonOxuRkIqSOFx/arcgis/rest/services/San_Diego_Field_Trip_WFL1/FeatureServer/1"

        // Places field names
        property string fldPlaceId: "GooglePlaceId"
        property string fldPlaceName: "Name"
        property string fldHomies: "Homies"
        property string fldBae: "Bae"
        property string fldKids: "Kids"
        property string fldParents: "Parents"
        property string fldSolo: "Solo"
        property string fldDogs: "Dogs"
        property string fldActivityLevel: "ActivityLevel"
        property string fldVenue: "Venue"
        property string fldDesc: "Description"
        property string fldPhotoUrl: "PhotoUrl"
        property string fldOperationalStatus: "OperationalStatus"
        property string fldAddress: "Address"
        property string fldPhone: "Phone"
        property string fldWebsite: "Website"
        property string fldPriceLevel: "PriceLevel"
        property string fldRating: "Rating"
        property string fldTotalRatings: "TotalRatings"
        property string fldAlwaysOpen: "AlwaysOpen"
        property string fldSunOpen: "SunOpen"
        property string fldSunClose: "SunClose"
        property string fldMonOpen: "MonOpen"
        property string fldMonClose: "MonClose"
        property string fldTuesOpen: "TuesOpen"
        property string fldTuesClose: "TuesClose"
        property string fldWedOpen: "WedOpen"
        property string fldWedClose: "WedClose"
        property string fldThursOpen: "ThursOpen"
        property string fldThursClose: "ThursClose"
        property string fldFriOpen: "FriOpen"
        property string fldFriClose: "FriClose"
        property string fldSatOpen: "SatOpen"
        property string fldSatClose: "SatClose"

        // Reviews field names
        property string fldAuthor: "Author"
        property string fldAuthorPhoto: "AuthorPhoto"
        property string fldRelTime: "RelTime"
        property string fldReview: "Review"
        property string fldReviewTime: "ReviewTime"

        // App colors
        property color colorPrimary1: "#1D2125"
        property color colorPrimary2: "#363A3F"
        property color colorPrimary3: "#45B582"
        property color colorSecondary1: "#FFFFFF"
        property color colorSecondary2: "#456BB5"

        // Fonts
        property alias fontSourceHindSiliguriRegular : fontSourceHindSiliguriRegular
        FontLoader {
            id: fontSourceHindSiliguriRegular
            source: app.folder.fileUrl("assets/fonts/HindSiliguri-Regular.ttf")
        }
        property alias fontSourceHindSiliguriSemiBold : fontSourceHindSiliguriSemiBold
        FontLoader {
            id: fontSourceHindSiliguriSemiBold
            source: app.folder.fileUrl("assets/fonts/HindSiliguri-SemiBold.ttf")
        }
        property alias fontSourceRobotoRegular : fontSourceRobotoRegular
        FontLoader {
            id: fontSourceRobotoRegular
            source: app.folder.fileUrl("assets/fonts/Roboto-Regular.ttf")
        }
        property alias fontSourceRobotoBold : fontSourceRobotoBold
        FontLoader {
            id: fontSourceRobotoBold
            source: app.folder.fileUrl("assets/fonts/Roboto-Bold.ttf")
        }

        // Geocode service
        property string locatorUrl: "https://geocode.arcgis.com/arcgis/rest/services/World/GeocodeServer"

        // Log in details
        property bool isGuest: false

        // App connectivity
        property bool isConnected: Networking.isOnline

        // Check if iPhone
        readonly property bool isIos: Qt.platform.os === "ios"
        // Check for iPhone notch
        property bool hasNotch: false

        // Conversions
        property real metersToMiles: 0.000621371

        // 3rd party directions links
        property url directionsGoogleUrl: "https://www.google.com/maps/dir/?api=1"
        property url directionsAppleUrl: "http://maps.apple.com/?"

        // Days dictionary for dates
        property var daysObj: ({0: "Sunday", 1: "Monday", 2: "Tuesday", 3: "Wednesday", 4: "Thursday", 5: "Friday", 6: "Saturday"})
        property var monthsObj: ({0: "Jan", 1: "Feb", 2: "Mar", 3: "Apr", 4: "May", 5: "Jun", 6: "Jul", 7: "Aug", 8: "Sep", 9: "Oct", 10: "Nov", 11: "Dec"})

        // Today and tomorrow dates for calendar button
        property string todayDate: ""
        property string tomorrowDate: ""

        // Favorites
        property var arrFavorites: []

        // Selections
        property string who: ""
        property string active: ""
        property string where: ""

        // Filters
        property string filterMaster: ""
        property string filterStatus: "OperationalStatus = 'OPERATIONAL'"
        property string filterWith: ""
        property string filterActive: ""
        property string filterVenue: ""

        // Sort (bestNearby, distance, rating)
        property string sortBy: "bestNearby"
        property var sortDescObj: ({"bestNearby": "Results are sorted by rank, calculated using an algorithm based on distance, rating, and total number of ratings.",
                                   "distance": "Results are sorted by distance, from closest to furthest away.",
                                   "rating": "Results are sorted by user rating, from highest to lowest."})
        property var sortReverseObj: ({"bestNearby": true,
                                          "distance": false,
                                          "rating": true})
        // Address searched for by user
        property string searchedAddress: "Address"
        property var searchedAddressPoint: null

        // Flag to check if user has clicked on map in place details
        property bool mapFromPlaceDetails: false

        function isIphoneWithNotch() {
            var unixName = AppFramework.systemInformation.unixMachine

            if (unixName.match(/iPhone(10|\d\d)/)) {
                switch(unixName) {
                case "iPhone10,1":
                case "iPhone10,4":
                case "iPhone10,2":
                case "iPhone10,5":
                    return false
                default:
                    return true
                }
            }
            return false
        }

        Component.onCompleted: {
            // Update color of status bar
            StatusBar.color = app.colorPrimary2

            // Check if phone has notch
            if (app.isIos && AppFramework.systemInformation.hasOwnProperty("unixMachine")) {
                if (isIphoneWithNotch()) {
                    app.hasNotch = true
                }
            }

            // Get today date
            var today = new Date()
            todayDate = app.monthsObj[today.getMonth()] + today.getDate()

            // Get tomorrow date
            var tomorrow = new Date(today)
            tomorrow.setDate(tomorrow.getDate() + 1)
            tomorrowDate = new Date(tomorrow).getDate()

            // Get favorites
            app.arrFavorites = dbFunctions.getFavorites()
            console.log(arrFavorites)
        }


        property alias stackView: stackView
        StackView {
            id: stackView
            anchors.fill: parent
            initialItem: loginPage
        }

        Component {
            id: loginPage

            LoginPage {}
        }

        Component {
            id: containerPage
            ContainerPage{}
        }

        property alias dbFunctions: dbFunctions
        DatabaseFunctions {
            id: dbFunctions
        }
    }
}

