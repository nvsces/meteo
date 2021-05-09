import 'dart:async';
import 'dart:convert';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

/// Sample time series data type.
class TimeSeriesSales {
  final DateTime time;
  final double sales;

  TimeSeriesSales(this.time, this.sales);
}

class ItemDetailsPage extends StatefulWidget {
  ItemDetailsPage({this.data, this.title});
  String title;
  List<TimeSeriesSales> data;
  @override
  _ItemDetailsPageState createState() => new _ItemDetailsPageState();
}

class _ItemDetailsPageState extends State<ItemDetailsPage> {
  @override
  Widget build(BuildContext context) {
    var series = [
      new charts.Series<TimeSeriesSales, DateTime>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeSeriesSales sales, _) => sales.time,
        measureFn: (TimeSeriesSales sales, _) => sales.sales,
        data: widget.data,
      )
    ];

    var chart = new charts.TimeSeriesChart(
      series,
      domainAxis: new charts.DateTimeAxisSpec(
        tickFormatterSpec: new charts.AutoDateTimeTickFormatterSpec(
          day: new charts.TimeFormatterSpec(
            format: 'mm',
            //transitionFormat: 'mm ss',
          ),
        ),
      ),
      animate: true,
    );

    var chartWidget = new Padding(
      padding: new EdgeInsets.all(10),
      child: new SizedBox(
        height: MediaQuery.of(context).size.height / 3,
        child: chart,
      ),
    );

    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Text(
            widget.title,
          ),
          chartWidget,
        ],
      ),
    );
  }
}
