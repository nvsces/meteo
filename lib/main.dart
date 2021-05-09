import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:meteo/widgets/charts_simple.dart';
import 'package:meteo/models/sensor_data.dart';
import 'package:meteo/pages/settings_page.dart';
import 'package:meteo/services/database.dart';
import 'package:meteo/extension_funs.dart';

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
      datas.clear();
      setState(() {
        snapshot.forEach((key, value) {
          traficData.add(SensorData.fromDatabase(value, key));
          datas.add(SensorData.fromDatabase(value, key));
        });
      });

      if (DatabaseService.isTrafficRedirection) {
        // перенаправление трафика с realtimeDatabase -> CloudFirestore
        DatabaseService.trafficRedirection(traficData);
      }
    });
  }

  @override
  void initState() {
    if (!kIsWeb)
      readRealTimeDatabase();
    else
      readFirestore();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (contex) => SettingsPage()),
                );
              },
              icon: Icon(Icons.settings)),
        ],
      ),
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
