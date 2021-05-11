import 'dart:async';
import 'dart:math';

import 'package:meteo/services/database.dart';

class ArduinoSimulyator {
  static bool isActive = false;
  static double distanceTemp = 20;
  static double distanceTemp1 = 20;
  static double distanceTemp2 = 20;
  static double distanceHum = 20;
  static double distanceHum1 = 20;
  static double distancePres = 760;
  static Timer timer;

  static generatedValue() {
    var random = Random();
    double temp = random.nextDouble() * distanceTemp;
    double temp1 = random.nextDouble() * distanceTemp1;
    double temp2 = random.nextDouble() * distanceTemp2;
    double hum = random.nextDouble() * distanceHum;
    double hum1 = random.nextDouble() * distanceHum1;
    double pres = random.nextDouble() * distancePres;

    return "${temp}q${temp1}q${temp2}q${hum}q${hum1}q${pres}q${DateTime.now()}";
  }

  static startTimer() {
    timer = Timer.periodic(Duration(seconds: 10), (timer) {
      if (ArduinoSimulyator.isActive)
        DatabaseService.db.push().set(ArduinoSimulyator.generatedValue());
    });
  }

  static stopTimer() {
    timer.cancel();
  }
}
