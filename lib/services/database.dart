import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:meteo/models/sensor_data.dart';

const databaseUrl =
    'https://meteo-b3f03-default-rtdb.europe-west1.firebasedatabase.app/';

class DatabaseService {
  static FirebaseApp _app;
  static DatabaseReference _db;
  static bool isTrafficRedirection = false;

  static get db => _db;

  static get app => _app;

  static initializeApp(FirebaseApp app) {
    _app = app;
    _db = FirebaseDatabase(app: app, databaseURL: databaseUrl)
        .reference()
        .child('your_db_child');
  }

  static CollectionReference _authCollection =
      FirebaseFirestore.instance.collection('AUTH');

  static void trafficRedirection(List<SensorData> datas) {
    datas.forEach((element) async {
      await _authCollection.doc(element.id).delete();
    });

    datas.forEach((element) async {
      await _authCollection.doc(element.id).set(element.toMap());
    });
  }

  static Stream<List<SensorData>> getSensors() {
    return _authCollection.snapshots().map((QuerySnapshot data) => data.docs
        .map((DocumentSnapshot doc) => SensorData.fromJson(doc.data()))
        .toList());
  }
}
