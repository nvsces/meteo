class SensorData {
  double temp;
  double temp1;
  double temp2;
  double hum;
  double hum1;
  double pres;
  String id;
  DateTime time;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'temp': temp,
      'temp1': temp1,
      'temp2': temp2,
      'hum': hum,
      'hum1': hum1,
      'pres': pres,
      'time': time.toString()
    };
  }

  SensorData.fromDatabase(String data, String id) {
    List<String> listValue = data.split('q');
    this.id = id;
    temp = double.parse(listValue[0]);
    temp1 = double.parse(listValue[1]);
    temp2 = double.parse(listValue[2]);
    hum = double.parse(listValue[3]);
    hum1 = double.parse(listValue[4]);
    pres = double.parse(listValue[5]);
    time = DateTime.parse(listValue[6]);
  }

  SensorData.fromJson(Map<String, dynamic> data) {
    id = data['id'];
    temp = data['temp'];
    temp1 = data['temp1'];
    temp2 = data['temp2'];
    hum = data['hum'];
    hum1 = data['hum1'];
    pres = data['pres'];
    time = DateTime.parse(data['time']);
  }
}
