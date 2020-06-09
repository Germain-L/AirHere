import 'package:geolocator/geolocator.dart';
import 'package:dio/dio.dart';
import 'package:connectivity/connectivity.dart';
import 'package:airhere/main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Data {
  Position devicePosition;

  String deviceAQI;
  String devicePositionName;

  String latitude;
  String longitude;
  String key = '59d27f689a6656ce32dd3b020956cbc38eca3139';

  String waqi;

  String deviceNO2;
  String deviceO3;
  String devicePM25;
  String devicePM10;

  ConnectivityResult deviceConnection;

  List stations;
  List markers = <Marker>[];

  
  Stream streamInit() async* {
    print("air init");

    yield ["getting device location", 10];
    devicePosition = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    print(devicePosition);



    latitude = devicePosition.latitude.toString();
    longitude = devicePosition.longitude.toString();

    waqi =
        'https://api.waqi.info/feed/geo:$latitude;$longitude/' + '?token=$key';


    yield ["Checking internet connectivity", 30];
    deviceConnection = await Connectivity().checkConnectivity();
    print(deviceConnection);


    yield ["Finding localised air quality", 50];
    await getAqi(waqi, deviceConnection);

    yield ["Finding worlwide air quality", 70];
    await retrieveDocs();

    yield ["Done", 100];

  }

  Future<bool> getAqi(String url, var connection) async {
    bool succ = false;
    if (connection != ConnectivityResult.none) {
      Response response = await Dio().get(url);
      if (response.statusCode == 200 && response.data['status'] == 'ok') {
        var data = response.data;

        deviceAQI = data['data']['aqi'].toString();

        devicePositionName = data['data']['city']['name'];

        deviceO3 = data['data']['iaqi']['o3']['v'].toString();
        devicePM25 = data['data']['iaqi']['pm25']['v'].toString();
        deviceNO2 = data['data']['iaqi']['no2']['v'].toString();
        devicePM10 = data['data']['iaqi']['pm10']['v'].toString();

        succ = true;
      }
    }
    return succ;
  }

  void buildMarkers() {
    stations.forEach((element) {
      markers.add(Marker(
        icon: BitmapDescriptor.defaultMarkerWithHue(colour(element['aqi'])),
        markerId: MarkerId(element['uid'].toString().toString()),
        position: LatLng(
          double.parse(element['lat'].toString()),
          double.parse(element['lon'].toString())
        ),
      ));
    });
  }

  double colour(String aqi) {
    double color;
    if (aqi == "-") {
      color = 0;
    } else {
      int aqiInt = int.parse(aqi);
      if (aqiInt >= 0 && aqiInt <= 50) {
        color = BitmapDescriptor.hueGreen;
      } else if (aqiInt >= 51 && aqiInt <= 100) {
        color = BitmapDescriptor.hueYellow;
      } else if (aqiInt >= 101 && aqiInt <= 150) {
        color = BitmapDescriptor.hueOrange;
      } else if (aqiInt >= 151 && aqiInt <= 200) {
        color = BitmapDescriptor.hueRed;
      } else if (aqiInt >= 201 && aqiInt <= 300) {
        color = BitmapDescriptor.hueMagenta;
      } else if (aqiInt >= 301) {
        color = BitmapDescriptor.hueViolet;
      }
    }
    return color;
  }

  Future retrieveDocs() async {
    var array = await databaseReference
        .collection("stations")
        .document("array")
        .get()
        .catchError((onError) {return false;});

    stations = array.data['array'];

    for (int i = 0; i < 15; i++){
      print(stations[i]);
    }
    buildMarkers();
    return true;
  }

  Map getData() {
    Map data = {
      'aqi': deviceAQI,
      'pm25': devicePM25,
      'pm10': devicePM10,
      'no2': deviceNO2,
      'o3': deviceO3,
      'position': devicePositionName
    };

    print('data: $data');

    return data;
  }
}
