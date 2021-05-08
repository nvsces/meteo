import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meteo/sensor_data.dart';

class DatabaseService {
  CollectionReference _routeCollection;

  static CollectionReference _authCollection =
      FirebaseFirestore.instance.collection('AUTH');

  Future setVkUrl(String authId, String url) async {
    Map<String, dynamic> map = {'vkurl': url};
    return await _authCollection.doc(authId).set(map);
  }

  static Future addValue() async {
    _authCollection.doc().set({'value': "1000"});
  }

  static void trafficRedirection(List<SensorData> datas) {
    datas.forEach((element) {
      _authCollection.doc().set(element.toMap());
    });
  }

  Stream<List<SensorData>> getTrips(String route) {
    return _routeCollection.snapshots().map((QuerySnapshot data) => data.docs
        .map((DocumentSnapshot doc) => SensorData.fromJson(doc.data()))
        .toList());
  }
}
