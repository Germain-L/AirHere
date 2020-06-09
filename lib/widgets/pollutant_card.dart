import 'package:flutter/material.dart';

class PollutantCard extends StatelessWidget {
  //widget has name and level added as  a decoration 
  PollutantCard({this.name, this.level});
  final name;
  final level;
  final TextStyle _pollutantStyle = TextStyle(fontSize: 25);
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(name, style: _pollutantStyle,),
            Divider(thickness: 1, color: Colors.black, indent: 10, endIndent: 10),
            Text(level, style: _pollutantStyle,),
          ],
        ),
      ),
    );
  }
}