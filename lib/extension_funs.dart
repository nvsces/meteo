import 'package:meteo/charts_simple.dart';
import 'package:meteo/models/sensor_data.dart';

extension sensorExtension on List<SensorData> {
  List<TimeSeriesSales> listType(int type) {
    List<TimeSeriesSales> graph = [];
    this.sort((a, b) {
      return a.time.compareTo(b.time);
    });
    this.forEach((element) {
      switch (type) {
        case SensorData.typeTemp:
          graph.add(TimeSeriesSales(element.time, element.temp));
          break;
        case SensorData.typeTemp1:
          graph.add(TimeSeriesSales(element.time, element.temp1));
          break;
        case SensorData.typeTemp2:
          graph.add(TimeSeriesSales(element.time, element.temp2));
          break;
        case SensorData.typeHum:
          graph.add(TimeSeriesSales(element.time, element.hum));
          break;
        case SensorData.typeHum1:
          graph.add(TimeSeriesSales(element.time, element.hum1));
          break;
        default:
          graph.add(TimeSeriesSales(element.time, element.pres));
      }
    });

    return graph;
  }
}
