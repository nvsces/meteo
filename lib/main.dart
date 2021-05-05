import 'dart:async';

import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:meteo/card_data.dart';
import 'package:meteo/graph_card.dart';
import 'package:meteo/graph_painter.dart';
import 'package:meteo/sensor_data.dart';

import 'funs.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FirebaseApp app = await Firebase.initializeApp();
  runApp(MaterialApp(
    home: MyHomePage(app: app),
  ));
}

class MyHomePage extends StatefulWidget {
  MyHomePage({this.app});
  final FirebaseApp app;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int count = 0;
  String text = 'value';
  List<SensorData> datas = [];

  get listTemp1 {
    List<double> graph = [];
    datas.sort((a, b) {
      return a.time.compareTo(b.time);
    });
    datas.forEach((element) {
      graph.add(element.temp1);
    });

    return graph;
  }

  get listHum {
    List<double> graph = [];
    datas.sort((a, b) {
      return a.time.compareTo(b.time);
    });
    datas.forEach((element) {
      graph.add(element.hum);
    });

    return graph;
  }

  get listHum1 {
    List<double> graph = [];
    datas.sort((a, b) {
      return a.time.compareTo(b.time);
    });
    datas.forEach((element) {
      graph.add(element.hum1);
    });

    return graph;
  }

  get listPress {
    List<double> graph = [];
    datas.sort((a, b) {
      return a.time.compareTo(b.time);
    });
    datas.forEach((element) {
      graph.add(element.pres);
    });

    return graph;
  }

  get listTem2 {
    List<double> graph = [];
    datas.sort((a, b) {
      return a.time.compareTo(b.time);
    });
    datas.forEach((element) {
      graph.add(element.temp2);
    });

    return graph;
  }

  void read() {
    final DatabaseReference db = FirebaseDatabase(
            app: widget.app,
            databaseURL:
                'https://meteo-b3f03-default-rtdb.europe-west1.firebasedatabase.app/')
        .reference()
        .child('your_db_child');
    var stream = db.onValue.listen((value) {
      print('value->${value.snapshot.value}');
      Map snapshot = value.snapshot.value;
      var listMap = snapshot.values.toList();
      datas.clear();
      setState(() {
        listMap.forEach((element) {
          datas.add(SensorData.fromDatabase(element));
        });
      });
    });
  }

  @override
  void initState() {
    read();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: ListView(
          children: [
            GraphCard(listTemp1),
            GraphCard(listHum),
            GraphCard(listHum1),
            GraphCard(listPress),
            GraphCard(listTem2),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.ac_unit),
        onPressed: () {
          count++;
          print('click');
          final DatabaseReference db = FirebaseDatabase(
                  app: widget.app,
                  databaseURL:
                      'https://meteo-b3f03-default-rtdb.europe-west1.firebasedatabase.app/')
              .reference()
              .child('your_db_child');

          db.push().set(generateData());
        },
      ),
    );
  }
}
