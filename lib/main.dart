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
import 'package:meteo/models/sensor_data.dart';
import 'package:meteo/services/database.dart';
import 'package:meteo/extension_funs.dart';

import 'funs.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FirebaseApp app = await Firebase.initializeApp();
  DatabaseService.initializeApp(app);
  runApp(MaterialApp(
    home: MyHomePage(),
  ));
}

class MyHomePage extends StatefulWidget {
  MyHomePage();

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<SensorData> datas = [];
  List<SensorData> traficData = [];

  // List<TimeSeriesSales> get listTemp1 {
  //   List<TimeSeriesSales> graph = [];
  //   datas.sort((a, b) {
  //     return a.time.compareTo(b.time);
  //   });
  //   datas.forEach((element) {
  //     graph.add(TimeSeriesSales(element.time, element.temp1));
  //   });

  //   return graph;
  // }

  // List<TimeSeriesSales> get listHum {
  //   List<TimeSeriesSales> graph = [];
  //   datas.sort((a, b) {
  //     return a.time.compareTo(b.time);
  //   });
  //   datas.forEach((element) {
  //     graph.add(TimeSeriesSales(element.time, element.hum));
  //   });
  //   return graph;
  // }

  // List<TimeSeriesSales> get listHum1 {
  //   List<TimeSeriesSales> graph = [];
  //   datas.sort((a, b) {
  //     return a.time.compareTo(b.time);
  //   });
  //   datas.forEach((element) {
  //     graph.add(TimeSeriesSales(element.time, element.hum1));
  //   });

  //   return graph;
  // }

  // List<TimeSeriesSales> get listPress {
  //   List<TimeSeriesSales> graph = [];
  //   datas.sort((a, b) {
  //     return a.time.compareTo(b.time);
  //   });
  //   datas.forEach((element) {
  //     graph.add(TimeSeriesSales(element.time, element.pres));
  //   });

  //   return graph;
  // }

  // List<TimeSeriesSales> get listTem2 {
  //   List<TimeSeriesSales> graph = [];
  //   datas.sort((a, b) {
  //     return a.time.compareTo(b.time);
  //   });
  //   datas.forEach((element) {
  //     graph.add(TimeSeriesSales(element.time, element.temp2));
  //   });

  //   return graph;
  // }

  void readFirestore() {
    DatabaseService.getSensors().listen((event) {
      datas.clear();
      setState(() {
        datas.addAll(event);
      });
    });
  }

  void readRealTimeDatabase() {
    var db = DatabaseService.db;
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

  @override
  void initState() {
    if (!kIsWeb) readRealTimeDatabase();
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
              data: datas.listType(SensorData.typeTemp),
              title: 'Температура',
            ),
            ItemDetailsPage(
              data: datas.listType(SensorData.typeTemp1),
              title: 'Температура 1',
            ),
            ItemDetailsPage(
              data: datas.listType(SensorData.typeHum),
              title: 'Влажность',
            ),
            ItemDetailsPage(
              data: datas.listType(SensorData.typeHum1),
              title: 'Влажность 2',
            ),
            ItemDetailsPage(
              data: datas.listType(SensorData.typeTemp2),
              title: 'Температура 2',
            ),
            ItemDetailsPage(
              data: datas.listType(SensorData.typePress),
              title: 'Давление',
            ),
          ],
        ),
      ),
    );
  }
}
