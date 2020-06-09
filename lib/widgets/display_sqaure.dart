import 'package:flutter/material.dart';

class AqiSquare extends StatelessWidget {
  final String value;
  AqiSquare({this.value});

  List<Color> _gradient(String aqiValue) {
    List<Color> gradient;

    if (aqiValue.contains("-")) {
      return [Colors.grey[500], Colors.grey[800]];
    }

    int aqi = int.parse(aqiValue);

    if (aqi >= 0 && aqi < 51) {
      gradient = [Colors.greenAccent[100], Colors.green[700]];
    } else if (aqi >= 51 && aqi < 101) {
      gradient = [Colors.yellowAccent[100], Colors.yellow[600]];
    } else if (aqi >= 101 && aqi < 151) {
      gradient = [Colors.orangeAccent[100], Colors.orange[700]];
    } else if (aqi >= 151 && aqi < 200) {
      gradient = [Colors.redAccent[100], Colors.red[700]];
    } else if (aqi >= 200 && aqi < 301) {
      gradient = [Colors.purpleAccent[100], Colors.purple[700]];
    } else if (aqi >= 301) {
      gradient = [
        Color.fromARGB(255, 126, 0, 35),
        Color.fromARGB(255, 123, 44, 66)
      ];
    }

    return gradient;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
              colors: _gradient(value),
              begin: Alignment.topLeft,
              end: Alignment.bottomRight)),
      height: 100,
      width: 100,
      child: Center(
          child: Text(
        value,
        style: TextStyle(fontSize: 40),
      )),
    );
  }
}
