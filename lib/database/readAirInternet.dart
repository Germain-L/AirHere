import 'package:sqflite/sqflite.dart';


// async* is used to "return" values even if the function is not finished
Stream getSavedPlaces() async* {

  //get database path and open the database
  var databasePath = await getDatabasesPath();
  String path = (databasePath + 'database.db');
  Database db = await openDatabase(path);

  //constantly run the code
  while (true) {
    //query the database to get every entries
    var items = await db.query('air_data_internet');

    // yield is used instead of return as it will not stop the function,
    // and still return elements
    yield items;
  }
}