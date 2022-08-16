import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class LineChart extends StatelessWidget {
  final List<LineChartData> chartData;

  const LineChart({required this.chartData});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      child: SfCartesianChart(
        primaryXAxis: CategoryAxis(
          labelRotation: chartData.length > 12 ? 90 : 0,
        ),
        series: <ChartSeries>[
          LineSeries<LineChartData, String>(
            dataSource: chartData,
            xValueMapper: (LineChartData data, _) => data.xValue,
            yValueMapper: (LineChartData data, _) => data.yValue,
          )
        ],
      ),
    );
  }
}

class LineChartData {
  String xValue;
  int yValue;

  LineChartData({required this.xValue, required this.yValue});
}
