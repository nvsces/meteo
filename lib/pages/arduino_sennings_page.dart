import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meteo/models/arduino_simulyator.dart';
import 'package:meteo/services/database.dart';

class ArduinoSettingPage extends StatefulWidget {
  ArduinoSettingPage();

  @override
  _ArduinoSettingPageState createState() => _ArduinoSettingPageState();
}

class _ArduinoSettingPageState extends State<ArduinoSettingPage> {
  TextEditingController tempC = TextEditingController();
  TextEditingController temp1C = TextEditingController();
  TextEditingController temp2C = TextEditingController();
  TextEditingController humC = TextEditingController();
  TextEditingController hum1C = TextEditingController();
  TextEditingController pressC = TextEditingController();

  void _apply() {
    if (tempC.text.isNotEmpty)
      ArduinoSimulyator.distanceTemp = double.parse(tempC.text);
    if (temp1C.text.isNotEmpty)
      ArduinoSimulyator.distanceTemp1 = double.parse(temp1C.text);
    if (temp2C.text.isNotEmpty)
      ArduinoSimulyator.distanceTemp2 = double.parse(temp2C.text);
    if (humC.text.isNotEmpty)
      ArduinoSimulyator.distanceHum = double.parse(humC.text);
    if (hum1C.text.isNotEmpty)
      ArduinoSimulyator.distanceHum1 = double.parse(hum1C.text);
    if (pressC.text.isNotEmpty)
      ArduinoSimulyator.distancePres = double.parse(pressC.text);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Симулятор Ардуино'),
      ),
      body: Container(
        child: Column(
          children: [
            Center(
              child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Text('Введите вверхнюю границу генерируемых величин')),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  labelText: 'Tемпература',
                ),
                controller: tempC,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  labelText: 'Tемпература 1',
                ),
                controller: temp1C,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  labelText: 'Tемпература 2',
                ),
                controller: temp2C,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  labelText: 'Влажность',
                ),
                controller: humC,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  labelText: 'Влажность 1',
                ),
                controller: hum1C,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  labelText: 'Давление',
                ),
                controller: pressC,
              ),
            ),
            ElevatedButton(onPressed: _apply, child: Text('Применить')),
          ],
        ),
      ),
    );
  }
}
