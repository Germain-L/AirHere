import 'package:airhere/app.dart';
import 'package:airhere/data/data.dart';
import 'package:airhere/data/firestore.dart';
import 'package:airhere/data/library_provider.dart';
import 'package:airhere/database/create.dart';
import 'package:airhere/pages/loader.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:airhere/pages/manage.dart';
import 'package:provider/provider.dart';

Data d = Data();
final databaseReference = Firestore.instance;

void main(List<String> args) {
  WidgetsFlutterBinding.ensureInitialized();
  createTables();
  update();
  runApp(
    MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => LoadScreen(),
        '/app': (context) => Top(),
      },
      theme: ThemeData(
          textTheme: TextTheme(
        headline5: TextStyle(fontSize: 30.0, fontStyle: FontStyle.italic),
        headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
      )),
    ),
  );
}
