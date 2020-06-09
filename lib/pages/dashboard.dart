import 'package:airhere/main.dart';
import 'package:airhere/widgets/dashboard_display.dart';
import 'package:flutter/material.dart';


class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Map data = d.getData();


  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Display(
            data: data
          ),
        ),
      ),
    );
  }
}