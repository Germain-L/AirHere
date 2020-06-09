import 'package:sqflite/sqflite.dart';

//data arguments represents what needs to be parsed in the table 
void writeAirDataInternet(data) async {
  //finds and opens database
  var databasePath = await getDatabasesPath();
  String path = (databasePath + 'database.db');
  Database db = await openDatabase(path);

  //searches for existing rows where name is the same as given name
  List exists = await db.rawQuery('''
SELECT name from air_data_internet WHERE name="${data['name'].toString()}"''');
  //if no rows create one and add the data
  if (exists.isEmpty) {
    db.insert('air_data_internet', {
      'name': data['name'],
      'lat': data['lat'],
      'lng':data['lng']
    });
  }
  //if row exists, update the data rather than create a new row
  else {
    db.update('air_data_internet', {
      'name': data['name'],
      'lat': data['lat'],
      'lng':data['lng'
      ]},
      
      where: 'name',
      whereArgs: data['name'],
    );
  }
}