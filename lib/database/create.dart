import 'package:sqflite/sqflite.dart';

// async function because the getDatabasesPath uses an async datatype that needs to be awaited 
void createTables() async {
  //searches the path of the database
  var databasesPath = await getDatabasesPath();
  String path = (databasesPath+ 'database.db');

  //opens the database, creates a table if needed
  openDatabase(path, version: 1,
    // if database.db is created here, then this code will run and add the tables 
    onCreate: (Database db, int version) async {
      //creates air_data_internet table
      await db.execute("CREATE TABLE air_data_internet (name TEXT, lat REAl, lng REAL)");
      print("databases screated");
    }
  );
}
