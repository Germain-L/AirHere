import 'package:flutter/material.dart';
import 'package:airhere/main.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


class LoadScreen extends StatefulWidget {
  @override
  _LoadScreenState createState() => _LoadScreenState();
}

class _LoadScreenState extends State<LoadScreen> with SingleTickerProviderStateMixin{

  @override
  void initState(){
    super.initState();
    d.streamInit().listen((data) {
      if(data[1] == 100){
        Navigator.pushReplacementNamed(context, '/app');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromRGBO(0, 67, 164, 1)
        ),  
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Card(
                  elevation: 5,
                  child: Container(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text("AirHere", style: Theme.of(context).textTheme.headline6,),
                        SizedBox(height: 5,),
                        Text("Loading required assets"),
                        SizedBox(height: 15,),
                        SpinKitWave(color: Colors.black, size: 30,),
                      ],
                    ),
                  )
                ),
              ],
            ),
          ],
        )
      
      ),
    );
  }
}
