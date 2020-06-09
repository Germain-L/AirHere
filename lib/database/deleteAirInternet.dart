import 'package:sqflite/sqflite.dart';

//has String name as an argument to let the user 
void deleteAirInternet(String name) async {
  //finds database
  var databasePath = await getDatabasesPath();
  String path = (databasePath + 'database.db');

  //opens database
  Database db = await openDatabase(path);

  //executes query to delete wanted content
  db..rawDelete('DELETE FROM air_data_internet WHERE name = ?', [name]);
}