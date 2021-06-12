import 'dart:async';
import 'dart:math';

import 'package:meteo/services/database.dart';

import '../funs.dart';

class ArduinoSimulyator {
  static bool isActive = false;
  static Timer timer;

  static int periodicTimer = 10;

  static List<double> _rangeGenerateValues = [
    20,
    25,
    60,
    80,
    20,
    25,
    60,
    80,
    20,
    25,
    750,
    770,
  ];

  static setRangeGenerateValues(List<double> data) {
    _rangeGenerateValues = data;
  }

  static generatedValue() {
    var random = Random();
    double temp = randomToRange(
      randomValue: random.nextDouble(),
      min: _rangeGenerateValues[0],
      max: _rangeGenerateValues[1],
    );
    double temp1 = randomToRange(
      randomValue: random.nextDouble(),
      min: _rangeGenerateValues[2],
      max: _rangeGenerateValues[3],
    );
    double temp2 = randomToRange(
      randomValue: random.nextDouble(),
      min: _rangeGenerateValues[4],
      max: _rangeGenerateValues[5],
    );
    double hum = randomToRange(
      randomValue: random.nextDouble(),
      min: _rangeGenerateValues[6],
      max: _rangeGenerateValues[7],
    );
    double hum1 = randomToRange(
      randomValue: random.nextDouble(),
      min: _rangeGenerateValues[8],
      max: _rangeGenerateValues[9],
    );
    double pres = randomToRange(
      randomValue: random.nextDouble(),
      min: _rangeGenerateValues[10],
      max: _rangeGenerateValues[11],
    );

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
