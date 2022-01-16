import QtQuick 2.0
import QtQuick.LocalStorage 2.0

Item {
    id: _root
    property var db: null

    function openDB() {
        if(db !== null) return;

        db = LocalStorage.openDatabaseSync("sdft", "0.1", "Database for storing favorites", 5000);

        try {
            db.transaction(function(tx){
                tx.executeSql('CREATE TABLE IF NOT EXISTS favorites(id TEXT UNIQUE)');
            });
        } catch (err) {
            console.log("Error creating table in database: " + err);
        };
    }

    function saveFavorite(id) {
        openDB();
        db.transaction( function(tx){
            tx.executeSql('INSERT INTO favorites VALUES(?)', [id]);
        });
    }

    function getFavorites() {
        openDB();
        var favoritesArr = [];
        var id;
        db.transaction(function(tx) {
            var rs = tx.executeSql('SELECT * FROM favorites;');
            for (var i = 0; i < rs.rows.length; i++) {
                id = rs.rows.item(i).id;
                favoritesArr.push(id);
            }
        });

        return favoritesArr
    }

    function deleteFavorite(id) {
        openDB();
        db.transaction( function(tx){
            var rs = tx.executeSql('DELETE FROM favorites WHERE id=?;', [id]);
        });
    }

    function sqlToJsDate(sqlDate){
        //console.log(sqlDate)
        //sqlDate in SQL DATETIME format ("yyyy-mm-ddThh:mm:ss.ms")
        var sqlDateArr1 = sqlDate.split("-");
        //format of sqlDateArr1[] = ['yyyy','mm','dd hh:mm:ms']
        var sYear = sqlDateArr1[0];
        var sMonth = (Number(sqlDateArr1[1]) - 1).toString();
        var sqlDateArr2 = sqlDateArr1[2].split("T");
        //format of sqlDateArr2[] = ['dd', 'hh:mm:ss.ms']
        var sDay = sqlDateArr2[0];
        var sqlDateArr3 = sqlDateArr2[1].split(":");
        //format of sqlDateArr3[] = ['hh','mm','ss.ms']
        var sHour = sqlDateArr3[0];
        var sMinute = sqlDateArr3[1];
        var sqlDateArr4 = sqlDateArr3[2].split(".");
        //format of sqlDateArr4[] = ['ss','ms']
        var sSecond = sqlDateArr4[0];
        var sMillisecond = sqlDateArr4[1];

        //console.log(new Date(sYear,sMonth,sDay,sHour,sMinute,sSecond,sMillisecond));
        return new Date(sYear,sMonth,sDay,sHour,sMinute,sSecond,sMillisecond);
    }
}
