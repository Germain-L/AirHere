import 'package:airhere/data/retrieve_staion_api.dart';
import 'package:airhere/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future retrieveDocs() async {
  // List stations = List();
  print("getting stations");

  var array = await databaseReference
      .collection("stations")
      .document("array")
      .get();

  List stations = array.data['array'];
  print("retrieved stations from firebase");
  return stations;
}


void update() async {
  var lastUpdated;

  //get current time
  Timestamp now = Timestamp.now();

  //retrieve timestamp from last updated on firebase
  final onValue = await databaseReference
      .collection("timestamp")
      .document('last_updated')
      .get();

  print(onValue);

  lastUpdated = onValue;

  Timestamp used = lastUpdated.data['time'];

  //compares times, stores as int (days)
  var difference = now.compareTo(used);

  //if last updated was more than a day ago, update it
  if (difference >= 1) {
    print("updating");
    writeToFire();
    writeTimestamp();
  }
}

Future<void> writeTimestamp() async {
  //open last_updated document and update it
  await databaseReference
      .collection("timestamp")
      .document("last_updated")
      .updateData({'time': Timestamp.now()}).whenComplete(
          () => print("time updated"));
  print("time updated");
}

Future writeToFire() async {
  List stations = await getStations(5);

  await databaseReference
      .collection("stations")
      .document("array")
      .setData({"array": stations})
      .then((v) => print("wrote"))
      .catchError((onError) => print("error"));
}
