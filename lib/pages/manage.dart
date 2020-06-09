import 'package:airhere/data/library_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//this class will allow the user to remove saved places.
class Manage extends StatefulWidget {
  @override
  _ManageState createState() => _ManageState();
}

class _ManageState extends State<Manage> {
  @override
  Widget build(BuildContext context) {
    final library = Provider.of<LibraryProvider>(context);
    return Material(
      child: Container(
        //background decoration
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.deepOrangeAccent, Colors.deepOrange],
          ),
        ),
        //futurebuilder awaits for program to read the database entry using readAirInternet()
        child: ListView.builder(
          itemCount: library.items.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    //this column will hold widgets in a vertical list
                    //will display the name and a button to remove
                    children: <Widget>[
                      Text(
                        library.items[index]['name'],
                        style: TextStyle(fontSize: 30),
                      ),
                      Divider(),
                      MaterialButton(
                        child: Text("Remove"),
                        onPressed: () {
                          library
                              .deleteAirInternet(library.items[index]['name']);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
