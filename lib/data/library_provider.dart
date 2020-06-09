import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

class LibraryProvider with ChangeNotifier {
  List items = List();
  List temp = List();

  void getSavedPlaces() async {
    var databasePath = await getDatabasesPath();
    String path = (databasePath + 'database.db');
    Database db = await openDatabase(path);

    items = await db.query('air_data_internet');

    notifyListeners();
  }

  void deleteAirInternet(String name) async {
    //finds database
    var databasePath = await getDatabasesPath();
    String path = (databasePath + 'database.db');

    //opens database
    Database db = await openDatabase(path);

    //executes query to delete wanted content
    db..rawDelete('DELETE FROM air_data_internet WHERE name = ?', [name]);
    getSavedPlaces();
  }
}
