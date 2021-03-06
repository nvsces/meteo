import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:meteo/funs.dart';
import 'package:meteo/pages/landing_page.dart';
import 'package:meteo/services/auth.dart';
import 'package:meteo/widgets/charts_simple.dart';
import 'package:meteo/models/sensor_data.dart';
import 'package:meteo/pages/settings_page.dart';
import 'package:meteo/services/database.dart';
import 'package:meteo/extension_funs.dart';
import 'package:provider/provider.dart';

import 'models/user.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FirebaseApp app = await Firebase.initializeApp();
  DatabaseService.initializeApp(app);
  runApp(
    MaterialApp(
      home: StreamProvider<User>.value(
          value: AuthService().currentUser, child: LandingPage()),
    ),
  );
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
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {});
      },
      child: Scaffold(
        backgroundColor: Colors.black,
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
                title: 'Температура DHT11',
                ylabel: 'Т,градусы',
              ),
              ItemDetailsPage(
                data: datas.listType(SensorData.typeTemp1),
                title: 'Влажность DHT11',
                ylabel: '%',
              ),
              ItemDetailsPage(
                data: datas.listType(SensorData.typeHum),
                title: 'Температура DHT22',
                ylabel: 'Т,градусы',
              ),
              ItemDetailsPage(
                data: datas.listType(SensorData.typeHum1),
                title: 'Влажность DHT22',
                ylabel: '%',
              ),
              ItemDetailsPage(
                data: datas.listType(SensorData.typeTemp2),
                title: 'Температура BMP180',
                ylabel: 'Т,градусы',
              ),
              ItemDetailsPage(
                data: datas.listType(SensorData.typePress),
                title: 'Давление BMP180',
                ylabel: 'мм.рт.ст.',
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => DatabaseService.db.push().set(generateData()),
        ),
      ),
    );
  }
}
