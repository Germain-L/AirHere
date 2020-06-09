import 'package:airhere/widgets/container.dart';
import 'package:flutter/material.dart';

class AqiBlock extends StatelessWidget {
  AqiBlock({this.future});
  final Future future;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: FutureBuilder(
        // function to fetch data can be changed as an argument
        future: future,
        // builds the widget
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          // branch if something has been returned
          if (snapshot.hasData) {
            // converts to a dyncamic variable for more maintainable access
            var data = snapshot.data;

            //branch if internet connection isn't available
            if (data['connectivity'] == false) {
              // inform the user about error
              return Card(child: Center(child: Text("No connection available")));
            } 
            // if internet connection is available
            else if (data['connectivity'] == true) {
          
              
              //branch if error returned from http request
              if (data['statusCode'] != 200) {
                // inform the user about error
                return Center(child: Text("No connection available"));
              }
              // if internet connection is available
              else if (data['connectivity'] == true) {
             

                //branch if error returned from http request
                if (data['statusCode'] != 200) {
                  // inform the user about error
                  return Center(
                    child: Text("Internal error occured"),
                  );
                }
                // if no errors, branch to display fetched data
                else if (data['statusCode'] == 200 && data['retrieved'] == "true") {
                  return Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(
                            data['name'],
                            style: TextStyle(fontSize: 25),
                          ),
                        ),
                      ),
                      Divider(indent: 20, endIndent: 20, thickness: 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("AQI: ", style: TextStyle(fontSize: 20, color: Colors.black)),
                          Text(data['aqi'], style: TextStyle(fontSize: 20, color: Colors.black))
                        ],
                      ),
                      Divider(indent: 20, endIndent: 20, thickness: 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          AqiContainer(
                            name: 'O₃',
                            index: data['o3'],
                          ),
                          Divider(indent: 20, endIndent: 20, thickness: 2), 
                          AqiContainer(
                            name: 'no₂',
                            index: data['no2'],
                          ),
                        ],
                      ),
                      Divider(indent: 20, endIndent: 20, thickness: 2), 
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          AqiContainer(
                            name: 'PM25',
                            index: data['pm25'],
                          ),
                          AqiContainer(
                            name: 'PM10',
                            index: data['pm10'],
                          ),
                        ],
                      )
                    ],
                  );
                } else if (data["retrieved"] == "false") {
                  return Center(child: Text("No further data available"));
                }
              }
            }
          }

          // while waiting for data, tell user that its loading
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(),
                SizedBox(height: 20,),
                Text("Gathering data")
              ],
            ),
          );
        }
      ),
    );
  }
}
