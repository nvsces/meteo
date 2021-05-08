import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:meteo/charts_simple.dart';
import 'package:meteo/sensor_data.dart';
import 'package:meteo/services/database.dart';

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
  List<SensorData> traficData = [];

  List<TimeSeriesSales> get listTemp1 {
    List<TimeSeriesSales> graph = [];
    datas.sort((a, b) {
      return a.time.compareTo(b.time);
    });
    datas.forEach((element) {
      graph.add(TimeSeriesSales(element.time, element.temp1));
    });

    return graph;
  }

  List<TimeSeriesSales> get listHum {
    List<TimeSeriesSales> graph = [];
    datas.sort((a, b) {
      return a.time.compareTo(b.time);
    });
    datas.forEach((element) {
      graph.add(TimeSeriesSales(element.time, element.hum));
    });
    return graph;
  }

  List<TimeSeriesSales> get listHum1 {
    List<TimeSeriesSales> graph = [];
    datas.sort((a, b) {
      return a.time.compareTo(b.time);
    });
    datas.forEach((element) {
      graph.add(TimeSeriesSales(element.time, element.hum1));
    });

    return graph;
  }

  List<TimeSeriesSales> get listPress {
    List<TimeSeriesSales> graph = [];
    datas.sort((a, b) {
      return a.time.compareTo(b.time);
    });
    datas.forEach((element) {
      graph.add(TimeSeriesSales(element.time, element.pres));
    });

    return graph;
  }

  List<TimeSeriesSales> get listTem2 {
    List<TimeSeriesSales> graph = [];
    datas.sort((a, b) {
      return a.time.compareTo(b.time);
    });
    datas.forEach((element) {
      graph.add(TimeSeriesSales(element.time, element.temp2));
    });

    return graph;
  }

  void readFirestore() {
    DatabaseService.getSensors().listen((event) {
      datas.clear();
      setState(() {
        datas.addAll(event);
      });
    });
  }

  void readRealTimeDatabase() {
    if (!kIsWeb) {
      final DatabaseReference db = FirebaseDatabase(
              app: widget.app,
              databaseURL:
                  'https://meteo-b3f03-default-rtdb.europe-west1.firebasedatabase.app/')
          .reference()
          .child('your_db_child');
      db.onValue.listen((value) {
        Map snapshot = value.snapshot.value;
        traficData.clear();
        setState(() {
          snapshot.forEach((key, value) {
            traficData.add(SensorData.fromDatabase(value, key));
          });
        });
        // перенаправление трафика с realtimeDatabase -> CloudFirestore
        DatabaseService.trafficRedirection(traficData);
      });
    }
  }

  @override
  void initState() {
    readRealTimeDatabase();
    readFirestore();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: ListView(
          children: [
            ItemDetailsPage(
              data: listTemp1,
              title: 'Температура',
            ),
            ItemDetailsPage(
              data: listHum,
              title: 'Влажность',
            ),
            ItemDetailsPage(
              data: listHum1,
              title: 'Влажность 2',
            ),
            ItemDetailsPage(
              data: listTem2,
              title: 'Температура 2',
            ),
            ItemDetailsPage(
              data: listPress,
              title: 'Давление',
            ),
            // GraphCard(listTemp1),
            // GraphCard(listHum),
            // GraphCard(listHum1),
            // GraphCard(listPress),
            // GraphCard(listTem2),
          ],
        ),
      ),
    );
  }
}
