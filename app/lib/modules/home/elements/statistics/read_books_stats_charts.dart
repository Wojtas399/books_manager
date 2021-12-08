import 'package:app/modules/home/bloc/home_bloc.dart';
import 'package:app/modules/home/bloc/home_query.dart';
import 'package:app/modules/home/elements/statistics/read_books_stats_charts_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../widgets/charts/doughnut_chart.dart';

class ReadBooksStatsCharts extends StatelessWidget {
  const ReadBooksStatsCharts();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeQuery>(
      builder: (context, query) {
        ReadBooksStatsChartsController controller =
            ReadBooksStatsChartsController(
          query: query,
        );
        return StreamBuilder(
          stream: controller.categoriesData$,
          builder: (_, AsyncSnapshot<List<DoughnutChartData>?> snapshot) {
            List<DoughnutChartData>? categoriesData = snapshot.data;
            if (categoriesData != null) {
              return StreamBuilder(
                stream: controller.pagesData$,
                builder: (_, AsyncSnapshot<PagesData?> snapshot2) {
                  PagesData? pagesData = snapshot2.data;
                  if (pagesData != null) {
                    return Container(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 8),
                          _CategoriesChart(categoriesData: categoriesData),
                          SizedBox(height: 16),
                          _PagesChart(pagesData: pagesData),
                          SizedBox(height: 16),
                        ],
                      ),
                    );
                  }
                  return Text('No data');
                },
              );
            }
            return Text('No data');
          },
        );
      },
    );
  }
}

class _CategoriesChart extends StatelessWidget {
  final List<DoughnutChartData> categoriesData;

  const _CategoriesChart({required this.categoriesData});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Kategorie',
          style: Theme.of(context).textTheme.headline6,
        ),
        SizedBox(height: 8),
        DoughnutChart(chartData: categoriesData, displayLegend: true),
      ],
    );
  }
}

class _PagesChart extends StatelessWidget {
  final PagesData pagesData;

  const _PagesChart({required this.pagesData});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Strony',
          style: Theme.of(context).textTheme.headline6,
        ),
        SizedBox(height: 8),
        DoughnutChart(
          chartData: [
            pagesData.readPages,
            pagesData.remainingPages,
          ],
        ),
        SizedBox(height: 8),
        _PagesSummary(
          readPages: pagesData.readPages.yValue,
          allPages: pagesData.allPages.yValue,
        ),
      ],
    );
  }
}

class _PagesSummary extends StatelessWidget {
  final int readPages;
  final int allPages;

  const _PagesSummary({
    required this.readPages,
    required this.allPages,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '$readPages/$allPages',
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ],
    );
  }
}
