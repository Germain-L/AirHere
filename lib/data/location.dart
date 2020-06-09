import 'package:google_maps_flutter/google_maps_flutter.dart';

class Location {
  String aqi;
  String no2;
  String o3;
  String pm25;
  String pm10;

  String locationName;
  LatLng location;

  Location({
    this.aqi,
    this.no2,
    this.o3,
    this.pm25,
    this.pm10,
    this.locationName,
    this.location,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
        aqi: json["data"]["aqi"] == null
            ? " - "
            : json["data"]["aqi"].toString(),
        no2: json["data"]["iaqi"]["no2"] == null
            ? " - "
            : json["data"]["iaqi"]["no2"]["v"].toString(),
        o3: json["data"]["iaqi"]["o3"] == null
            ? " - "
            : json["data"]["iaqi"]["o3"]["v"].toString(),
        pm25: json["data"]["iaqi"]["pm25"] == null
            ? " - "
            : json["data"]["iaqi"]["pm25"]["v"].toString(),
        pm10: json["data"]["iaqi"]["pm10"] == null
            ? " - "
            : json["data"]["iaqi"]["pm10"]["v"].toString(),
        locationName: json["data"]["city"]["name"].toString(),
        location: LatLng(
            json["data"]["city"]["geo"][0], json["data"]["city"]["geo"][1]));
  }
}
