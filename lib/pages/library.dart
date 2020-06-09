import 'package:airhere/data/library_provider.dart';
import 'package:airhere/widgets/location_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class Library2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final library = Provider.of<LibraryProvider>(context);
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 8.0,
              top: 3,
            ),
            child: Text(
              "Saved places:",
              style: TextStyle(
                fontSize: 25,
              ),
            ),
          ),
          Divider(
            indent: 8,
            endIndent: 8,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: library.items.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    Card(
                      elevation: 3,
                      child: LocationWidget(
                        position: LatLng(
                          library.items[index]["lat"],
                          library.items[index]["lng"],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          RaisedButton(
                            color: Colors.white,
                            onPressed: () => library.deleteAirInternet(
                                library.items[index]["name"]),
                            child: Text("Remove"),
                          )
                        ],
                      ),
                    )
                  ],
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
