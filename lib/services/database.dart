import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meteo/sensor_data.dart';

class DatabaseService {
  static CollectionReference _authCollection =
      FirebaseFirestore.instance.collection('AUTH');

  static Future addValue() async {
    _authCollection.doc().set({'value': "1000"});
  }

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
