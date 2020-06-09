import 'package:airhere/data/location.dart';
import 'package:airhere/widgets/display_sqaure.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Dio dio = Dio();

class LocationWidget extends StatelessWidget {
  final LatLng position;

  LocationWidget({@required this.position});

  Future<Map<String, dynamic>> getLocationData(LatLng loc) async {
    ConnectivityResult connectivity = await Connectivity().checkConnectivity();

    Location location;

    bool success = false;

    String url =
        'https://api.waqi.info/feed/geo:${loc.latitude};${loc.longitude}/' +
            '?token=59d27f689a6656ce32dd3b020956cbc38eca3139';

    if (connectivity == ConnectivityResult.mobile ||
        connectivity == ConnectivityResult.wifi) {
      Response response = await dio.get(url);

      switch (response.statusCode) {
        case (200):
          location = Location.fromJson(response.data);
          success = true;
          break;
        default:
          break;
      }
    }

    return Map.from({"status": success, "data": location});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        FutureBuilder<Map>(
          future: getLocationData(position),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              switch (snapshot.data["status"]) {
                case true:
                Location location = snapshot.data["data"];
                return Column(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width - 10,
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: Flex(
                        direction: Axis.vertical,
                        children: <Widget>[
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Text(
                              location.locationName,
                              style: TextStyle(fontSize: 25),
                            ),
                          ),
                          Divider(),
                          Flex(
                            direction: Axis.horizontal,
                            children: <Widget>[
                              Expanded(
                                flex: 75,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        Text(
                                          "PM25: ${location.pm25}",
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        Divider(),
                                        Text(
                                          "PM10: ${location.pm10}",
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        Text(
                                          "no2: ${location.no2}",
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        Divider(),
                                        Text(
                                          "o3: ${location.o3}",
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 25,
                                child: AqiSquare(value: location.aqi),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                );
                case false:
                  return Container(
                    child: Center(
                      child: Text("Error occured"),
                    ),
                  );
              }
            }
            return Container(
              height: 50,
              child: Center(
                child: CircularProgressIndicator()
              ),
            );
          },
        ),
      ],
    );
  }
}
