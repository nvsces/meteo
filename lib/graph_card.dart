import 'package:flutter/material.dart';

import 'graph_painter.dart';

class GraphCard extends StatelessWidget {
  GraphCard(this.listData);

  List<double> listData;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(children: [
          Row(children: [
            RotatedBox(
              quarterTurns: 3,
              child: Text('Ось y'),
            ),
            Expanded(
              child: CustomPaint(
                painter: GraphPainter(
                  listData,
                ),
                child: Container(
                  height: MediaQuery.of(context).size.height / 2,
                  width: MediaQuery.of(context).size.width,
                ),
              ),
            ),
          ]),
          Text('Ось x')
        ]),
      ),
    );
  }
}
