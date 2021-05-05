class SensorData {
  double temp;
  double temp1;
  double temp2;
  double hum;
  double hum1;
  double pres;

  DateTime time;

  SensorData.fromDatabase(String data) {
    List<String> listValue = data.split('q');
    temp = double.parse(listValue[0]);
    temp1 = double.parse(listValue[1]);
    temp2 = double.parse(listValue[2]);
    hum = double.parse(listValue[3]);
    hum1 = double.parse(listValue[4]);
    pres = double.parse(listValue[5]);
    time = DateTime.parse(listValue[6]);
  }
}
