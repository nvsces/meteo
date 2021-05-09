import 'package:flutter/material.dart';
import 'package:meteo/models/sensor_data.dart';

class CardData extends StatelessWidget {
  CardData(this.sensorData, {Key key}) : super(key: key);
  SensorData sensorData;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        child: Column(
          children: [
            Text('${sensorData.temp}'),
            Text('${sensorData.temp1}'),
            Text('${sensorData.temp2}'),
            Text('${sensorData.hum}'),
            Text('${sensorData.hum1}'),
            Text('${sensorData.pres}'),
          ],
        ),
      ),
    );
  }
}
