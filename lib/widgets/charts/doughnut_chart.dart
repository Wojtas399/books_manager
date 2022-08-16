import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DoughnutChart extends StatelessWidget {
  final List<DoughnutChartData> chartData;
  final bool? displayLegend;

  const DoughnutChart({required this.chartData, this.displayLegend});

  @override
  Widget build(BuildContext context) {
    List<_LegendData> legendData = chartData
        .map((elem) => _LegendData(
              name: elem.xValue,
              color: elem.color,
            ))
        .toList();

    return Column(
      children: [
        Container(
          height: 250,
          child: SfCircularChart(
            series: [
              DoughnutSeries<DoughnutChartData, String>(
                dataSource: chartData,
                xValueMapper: (DoughnutChartData data, _) => data.xValue,
                yValueMapper: (DoughnutChartData data, _) => data.yValue,
                pointColorMapper: (DoughnutChartData data, _) => HexColor(
                  data.color,
                ),
                name: 'Sales',
                dataLabelSettings: DataLabelSettings(
                  isVisible: true,
                  textStyle: TextStyle(fontSize: 14),
                ),
                radius: '100%',
              )
            ],
          ),
        ),
        displayLegend == true ? _Legend(data: legendData) : SizedBox(height: 0),
      ],
    );
  }
}

class _Legend extends StatelessWidget {
  final List<_LegendData> data;

  const _Legend({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      width: double.infinity,
      child: Wrap(
        alignment: WrapAlignment.center,
        children: [
          ...data.map((itemData) => _LegendItem(data: itemData)),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final _LegendData data;

  const _LegendItem({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: HexColor(data.color),
            ),
          ),
          SizedBox(width: 8),
          Text(data.name),
        ],
      ),
    );
  }
}

class DoughnutChartData {
  String xValue;
  int yValue;
  String color;

  DoughnutChartData({
    required this.xValue,
    required this.yValue,
    required this.color,
  });
}

class _LegendData {
  String name;
  String color;

  _LegendData({required this.name, required this.color});
}
