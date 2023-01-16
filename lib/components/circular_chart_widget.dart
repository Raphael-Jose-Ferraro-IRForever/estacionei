import 'package:estacionei/utils/colors_util.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../models/history_model.dart';

class CircularChartWidget extends StatefulWidget {

  const CircularChartWidget({required this.history, super.key});
  final HistoryModel history;

  @override
  State<CircularChartWidget> createState() => _CircularChartWidgetState();
}

class _CircularChartWidgetState extends State<CircularChartWidget> {

  late double total = widget.history.paid + widget.history.unPaid;

  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        sectionsSpace: 5,
        centerSpaceRadius: 100,
        sections: showingSections(),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(2, (i) {
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: ColorsUtil.verde,
            value: (widget.history.paid * 100) / total ,
            radius: 5,
            showTitle: false
          );
        case 1:
          return PieChartSectionData(
            color:  ColorsUtil.laranja,
            value: (widget.history.unPaid * 100) / total,
            radius: 5,
            showTitle: false
          );
        default:
          throw Error();
      }
    });
  }
}