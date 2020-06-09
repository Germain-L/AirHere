import 'dart:convert' as convert;
import 'dart:core';

import 'package:airhere/api_keys.dart';
import 'package:connectivity/connectivity.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<Map> getLocationData(LatLng loc) async {
  Map data = Map();
  
  //gets device's internet connection 
  var internetState = await (Connectivity().checkConnectivity());

  // when devices has internet conncetion availalble run then fetch data from internet
  if (internetState == ConnectivityResult.mobile ||
      internetState == ConnectivityResult.wifi) {
    
    // adds connectivity to the returned map for error handling
    data.putIfAbsent('connectivity', () => true);

    //if loc is parsed as a future getLocation(), needs to be awaited
    

    //creates the url for the api endpoint call with location
    String url =
        'https://api.waqi.info/feed/geo:${loc.latitude};${loc.longitude}/'+
        '?token=$waqiKey';

    http.Response response = await http.get(url);

    //repsonse has different attributes, including a status, if 200, get request was successful.
    if (response.statusCode == 200) {
      data.putIfAbsent('statusCode', () => response.statusCode);

      //parses response into a json format for easier access
      Map jsonResponseData = convert.jsonDecode(response.body)['data'];
      try{
        Map pollutants = jsonResponseData['iaqi'];
        Map variables = {
          'no2': pollutants.containsKey('no2') ? pollutants['no2']['v'].toString() : "-",
          'o3': pollutants.containsKey('o3') ? pollutants['o3']['v'].toString() : "-",
          'pm10': pollutants.containsKey('pm10') ? pollutants['pm10']['v'].toString() : "-",
          'pm25': pollutants.containsKey('pm25') ? pollutants['pm25']['v'].toString() : "-",
          'name': jsonResponseData['city']['name'].toString(),
          'aqi': jsonResponseData['aqi'].toString(),
        };
        //loops through the variables and adds them to data map
        variables.forEach((k, v) {
          data.putIfAbsent(k, () => v);
        });
        data.putIfAbsent("retrieved", () => "true");
      } catch (e) {
        print(e);
        data.putIfAbsent("retrieved", () => "false");
      }

    } else {
      //adds statuscode to data map
      data.putIfAbsent('statusCode', () => response.statusCode);
    }
  
  } else {
    //adds connectivity status to data.dart
    print("no internet available");
    data.putIfAbsent('connectivity', () => false);
  }

  //returns data
  return data;
}
