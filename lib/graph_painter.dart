import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meteo/funs.dart';
import 'package:meteo/sensor_data.dart';

const axexPadding = 10.0;
const axexStart = 5.0;

class GraphPainter extends CustomPainter {
  List<double> sensors;
  GraphPainter(
    this.sensors,
  );

  @override
  void paint(Canvas canvas, Size size) {
    if (sensors.length > 0)
      paintGraph(canvas, size, sensors, sensors.length, Colors.blue);
    ;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  List<double> normGraph(List<double> graph) {
    if (graph.length > 0) {
      var max = graph[0].abs();
      if (max == 0) max = 1;
      for (int i = 1; i < graph.length; i++) {
        if (graph[i].abs() > max) max = graph[i].abs();
      }

      for (int j = 0; j < graph.length; j++) {
        graph[j] = graph[j] / max;
      }
    }
    return graph;
  }

  List<double> copyList(List<double> graphCopy) {
    List<double> copy = [];
    copy.addAll(graphCopy);
    return copy;
  }

  //рисует оси
  void graphAxex(Canvas canvas, Size size) {
    canvas.drawLine(
      Offset(axexStart, 0),
      Offset(axexStart, size.height - axexStart),
      Paint(),
    );
    canvas.drawLine(
      Offset(axexStart, size.height - axexStart),
      Offset(size.width, size.height - axexStart),
      Paint(),
    );
    canvas.drawLine(Offset(axexStart, 0), Offset(0, 20), Paint());
    canvas.drawLine(Offset(axexStart, 0), Offset(2 * axexStart, 20), Paint());

    canvas.drawLine(
      Offset(size.width, size.height - axexStart),
      Offset(size.width - 20, size.height),
      Paint(),
    );

    canvas.drawLine(
      Offset(size.width, size.height - axexStart),
      Offset(size.width - 20, size.height - 2 * axexStart),
      Paint(),
    );
  }

  void paintGraph(
      Canvas canvas, Size size, List<double> data, int length, Color color) {
    graphAxex(canvas, size);

    List<double> paintData = copyList(data);
    double minValue = serchMin(paintData);
    paintData = normValue(paintData, minValue);
    paintData = normGraph(paintData);

    var paint = Paint()..color = color;
    var paintCrcle = Paint()..color = Colors.red;
    paint.strokeWidth = 3.0;
    print('длина $length');
    var rtx1 = 0.0 + axexPadding;
    var rty1 = size.height * paintData[0];
    for (int p = 0; p < length; p++) {
      var rty2 = size.height * paintData[p];
      var rtx2 = size.width * p / length + axexPadding;
      canvas.drawLine(Offset(rtx1, size.height - rty1),
          Offset(rtx2, size.height - rty2), paint);
      canvas.drawCircle(Offset(rtx2, size.height - rty2), 5, paintCrcle);
      rtx1 = rtx2;
      rty1 = rty2;
    }
  }
}
