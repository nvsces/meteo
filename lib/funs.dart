import 'dart:math';

import 'package:fluttertoast/fluttertoast.dart';

String generateData() {
  var random = Random();
  int scale = 50;
  double temp = random.nextDouble() * scale;
  double temp1 = random.nextDouble() * scale;
  double temp2 = random.nextDouble() * scale;
  double hum = random.nextDouble() * scale;
  double hum1 = random.nextDouble() * scale;
  double pres = random.nextDouble() * scale;

  return "${temp}q${temp1}q${temp2}q${hum}q${hum1}q${pres}q${DateTime.now()}";
}

double randomToRange({double randomValue, double min, double max}) {
  return min + randomValue * (max - min);
}

void showToast(String message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      fontSize: 16.0);
}

double serchMin(List<double> data) {
  if (data.isEmpty) return 1;
  double minValue = data[0];
  for (int i = 1; i < data.length; i++) {
    if (data[i] < minValue) {
      minValue = data[i];
    }
  }

  return minValue;
}

List<double> normValue(List<double> graph, double value) {
  for (int j = 0; j < graph.length; j++) {
    graph[j] = graph[j] / value;
  }
  return graph;
}
