import 'dart:convert' as convert;
import 'dart:core';

import 'package:airhere/api_keys.dart';
import 'package:http/http.dart' as http;


Future<List> getStations(double divisions) async {
  //parameter divisions is currently useless as it is hard coded into the app,
  //however i plan on making it a setting available for the user
  //the higher the number, the more stations will appear on the map.

  //declaring and initiating variables
  
  List stations = List();
  List bounds = List();
  double lng = -180;
  double toAdd = 180/divisions;

  double lat1 = -90;
  double lat2 = lat1 + toAdd;

  int numberOfCalls = 0;

  final creationWatch = Stopwatch()..start();
  //create map coordinates used to retreive stations given an area
  while (lat2 <= 90) {
    //resets longitude
    lng = -180;

    while (lng <= 180) {
      var temp = lng + 180;
      List newBounds = [lat1, lng, lat2, temp];
      lng = temp;

      bounds.add(newBounds);
    }

    //increments latitude for next bounds
    lat1 = lat2;
    lat2 += toAdd;
  }

  final creationTime = creationWatch.elapsed;
  creationWatch.stop();


  final callsWatch = Stopwatch()..start();
  //retrieves every stations available inbetween each area
  //defined by the bounds in the list bounds
  for (var positions in bounds) {
    //creates url to use in API
    String url = 
      'https://api.waqi.info/map/bounds/?latlng=${positions[0]},${positions[1]},'+
      '${positions[2]},${positions[3]}&token=$waqiKey';

    //sends requests
    http.Response response = await http.get(url);

    //stations retrieved addded to a list, 
    //convert.jsonDecode is parsing response into an accessible JSON format '
    List tempStations = convert.jsonDecode(response.body)['data'];

    //iterate tempStations and add each item to final list of stations
    tempStations.forEach((station) => stations.add(station));
    numberOfCalls++;
  }
  final callsTime = callsWatch.elapsed;
  callsWatch.stop();

  print("$numberOfCalls https calls, with ${stations.length} stations");
  print("took $creationTime to create, and $callsTime to call");
  return stations;
}
