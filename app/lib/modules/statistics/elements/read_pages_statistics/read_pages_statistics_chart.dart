import 'package:app/core/day/day_query.dart';
import 'package:app/modules/statistics/elements/read_pages_statistics/read_pages_statistics_controller.dart';
import 'package:app/modules/statistics/elements/report_type_dropdown_form_field.dart';
import 'package:app/widgets/buttons/raw_material_icon_button.dart';
import 'package:app/widgets/charts/line_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReadPagesStatisticsChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ReadPagesStatisticsController controller = ReadPagesStatisticsController(
      dayQuery: context.read<DayQuery>(),
    );

    return StreamBuilder(
      stream: controller.chartData$,
      builder: (_, AsyncSnapshot<List<LineChartData>> snapshot) {
        List<LineChartData>? chartData = snapshot.data;
        if (chartData != null) {
          return Column(
            children: [
              Text(
                'Przeczytane strony',
                style: Theme.of(context).textTheme.headline6,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ReportTypeDropdownFormField(
                  onChanged: (ReportType reportType) {
                    controller.onChangeReportType(reportType);
                  },
                ),
              ),
              SizedBox(height: 8),
              _ChartController(
                chartDate$: controller.chartTitleDate$,
                onChangeDateBack: controller.onChangeDateBack,
                onChangeDateForward: controller.onChangeDateForward,
              ),
              LineChart(chartData: chartData),
            ],
          );
        }
        return SizedBox(height: 0);
      },
    );
  }
}

class _ChartController extends StatelessWidget {
  final Stream<String> chartDate$;
  final Function onChangeDateBack;
  final Function onChangeDateForward;

  const _ChartController({
    required this.chartDate$,
    required this.onChangeDateBack,
    required this.onChangeDateForward,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RawMaterialIconButton(
          icon: Icons.arrow_back_ios_rounded,
          onClick: onChangeDateBack,
        ),
        SizedBox(width: 16),
        _ChartDate(chartDate$: chartDate$),
        SizedBox(width: 16),
        RawMaterialIconButton(
          icon: Icons.arrow_forward_ios_rounded,
          onClick: onChangeDateForward,
        ),
      ],
    );
  }
}

class _ChartDate extends StatelessWidget {
  final Stream<String> chartDate$;

  const _ChartDate({required this.chartDate$});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: chartDate$,
      builder: (_, AsyncSnapshot<String> snapshot) {
        String? chartDate = snapshot.data;
        if (chartDate != null) {
          return Text(chartDate, style: Theme.of(context).textTheme.bodyText1);
        }
        return SizedBox(height: 0);
      },
    );
  }
}
