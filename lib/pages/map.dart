import 'dart:async';

import 'package:airhere/api_keys.dart';
import 'package:airhere/data/saved_requests.dart';
import 'package:airhere/main.dart';
import 'package:airhere/widgets/aqi_block.dart';
import 'package:airhere/widgets/location_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:airhere/database/writeairinternet.dart';
import 'package:line_icons/line_icons.dart';
import 'package:search_map_place/search_map_place.dart';

class Map extends StatefulWidget {
  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> with AutomaticKeepAliveClientMixin {
  Widget _scale(Color colour, String nums, String def) {
    TextStyle textStyle = TextStyle(fontSize: 20, color: Colors.black);
    return Container(
      color: colour,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              nums,
              style: textStyle,
            ),
            Text(
              def,
              style: textStyle,
            ),
          ],
        ),
      ),
    );
  }

  Column _buildBottomScale() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _scale(Colors.green, "0 - 50", "Good"),
        _scale(Colors.yellow, "51 - 100", "Moderate"),
        _scale(Colors.orange, "101 - 150", "Poor"),
        _scale(Colors.red, "151 - 200", "Unhealthy"),
        _scale(Colors.purple, "201 - 300", "Very unhealthy"),
        _scale(Colors.brown, ">301", "Hazardous"),
      ],
    );
  }

  void _onButtonPressed() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            color: Colors.transparent,
            child: Container(
              child: _buildBottomScale(),
            ),
          );
        });
  }

  Widget fab() {
    return FloatingActionButton(
      backgroundColor: Color.fromRGBO(0, 67, 164, 1),
      heroTag: null,
      child: Icon(Icons.info),
      onPressed: () => _onButtonPressed(),
    );
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

  void _showBottomSheetMarkers(LatLng coordinates, String name) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              LocationWidget(
                position: coordinates,
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 1.0, right: 1.0, top: 8.0, bottom: 15),
                child: GestureDetector(
                  onTap: () {
                    writeAirDataInternet({
                      'name': name,
                      'lat': coordinates.latitude,
                      'lng': coordinates.longitude,
                    });
                    Navigator.pop(context);
                  },
                  child: Card(
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Text(
                            "Add to library",
                            style: Theme.of(context).textTheme.headline5,
                          ),
                          Icon(LineIcons.save)
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          );
        });
  }

  Set buildMarkers() {
    d.stations.forEach((element) {
      markers.add(Marker(
        onTap: () => _showBottomSheetMarkers(
            LatLng(element['lat'], element['lon']), element['station']['name']),
        icon: BitmapDescriptor.defaultMarkerWithHue(colour(element['aqi'])),
        markerId: MarkerId(element['uid'].toString().toString()),
        position: LatLng(double.parse(element['lat'].toString()),
            double.parse(element['lon'].toString())),
      ));
    });

    return markers;
  }

  GoogleMapController mapController;

  final Completer<GoogleMapController> _controller = Completer();

  final LatLng _center =
      LatLng(d.devicePosition.latitude, d.devicePosition.longitude);

  _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  bool get wantKeepAlive => true;

  Set<Marker> markers = Set<Marker>();

  GoogleMap _map;

  // var camPosition = mapController.getLatLng(ScreenCoordinate(x: middle, y: middle));

  @mustCallSuper
  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (_map == null) {
      _map = GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 11.0,
        ),
        markers: buildMarkers(),
        mapType: MapType.hybrid,
        compassEnabled: false,
        mapToolbarEnabled: false,
        buildingsEnabled: false,
        rotateGesturesEnabled: false,
        tiltGesturesEnabled: false,
        trafficEnabled: false,
        myLocationEnabled: true,
      );
    }
    return Container(
      child: Stack(
        children: <Widget>[
          _map,
          Positioned(
            top: 40,
            left: MediaQuery.of(context).size.width * 0.05,
            child: SearchMapPlaceWidget(
              apiKey: googleKey,
              onSelected: (place) async {
                final geolocation = await place.geolocation;

                final GoogleMapController controller = await _controller.future;
                FocusScope.of(context).unfocus();

                controller.animateCamera(
                    CameraUpdate.newLatLng(geolocation.coordinates));
                controller.animateCamera(
                    CameraUpdate.newLatLngBounds(geolocation.bounds, 0));
              },
            ),
          ),
          Positioned(
            right: 10,
            bottom: 10,
            child: fab(),
          ),
        ],
      ),
    );
  }
}
