import 'package:flutter/material.dart';

class AqiContainer extends StatelessWidget {
  AqiContainer({this.name, this.index});
  final String name;
  final String index;

  final TextStyle aqiTextStyle = TextStyle(fontSize: 25, color: Colors.black);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(40)),
            color: Colors.transparent),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                '$name: ',
                style: aqiTextStyle,
              ),
              Text(
                '$index',
                style: aqiTextStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
