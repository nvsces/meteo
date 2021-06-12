import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meteo/funs.dart';
import 'package:meteo/models/arduino_simulyator.dart';
import 'package:meteo/services/database.dart';
import 'package:meteo/widgets/row_text_field.dart';

class ArduinoSettingPage extends StatefulWidget {
  ArduinoSettingPage();

  @override
  _ArduinoSettingPageState createState() => _ArduinoSettingPageState();
}

class _ArduinoSettingPageState extends State<ArduinoSettingPage> {
  List<TextEditingController> controllers = [];

  @override
  void initState() {
    for (int i = 0; i < 12; i++) {
      controllers.add(TextEditingController());
    }
    super.initState();
  }

  // TextEditingController tempCLow = TextEditingController();
  // TextEditingController temp1C = TextEditingController();
  // TextEditingController temp2C = TextEditingController();
  // TextEditingController humC = TextEditingController();
  // TextEditingController hum1C = TextEditingController();
  // TextEditingController pressC = TextEditingController();

  bool checkIsNotEmptyController() {
    bool rezult = true;
    controllers.forEach((element) {
      if (element.text.isEmpty) rezult = false;
    });
    return rezult;
  }

  void _apply() {
    List<double> rangeGenerateValues = [];
    if (checkIsNotEmptyController()) {
      controllers.forEach((element) {
        rangeGenerateValues.add(double.parse(element.text));
      });
      ArduinoSimulyator.setRangeGenerateValues(rangeGenerateValues);
    } else {
      showToast('Заполните все поля');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Симулятор Ардуино'),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Center(
                child: Padding(
                    padding: EdgeInsets.all(10),
                    child:
                        Text('Введите вверхнюю границу генерируемых величин')),
              ),
              Text('Tемпература DHT11'),
              RowTextField(
                cLow: controllers[0],
                cHeigh: controllers[1],
              ),
              Text('Влажность DHT11'),
              RowTextField(
                cLow: controllers[2],
                cHeigh: controllers[3],
              ),
              Text('Температура DHT22'),
              RowTextField(
                cLow: controllers[4],
                cHeigh: controllers[5],
              ),
              Text('Влажность DHT22'),
              RowTextField(
                cLow: controllers[6],
                cHeigh: controllers[7],
              ),
              Text('Температура BMP180'),
              RowTextField(
                cLow: controllers[8],
                cHeigh: controllers[9],
              ),
              Text('Давление BMP180'),
              RowTextField(
                cLow: controllers[10],
                cHeigh: controllers[11],
              ),
              ElevatedButton(onPressed: _apply, child: Text('Применить')),
            ],
          ),
        ),
      ),
    );
  }
}
