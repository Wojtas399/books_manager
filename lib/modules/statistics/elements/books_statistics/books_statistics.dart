import 'package:app/core/book/book_query.dart';
import 'package:app/core/services/book_category_service.dart';
import 'package:app/modules/statistics/elements/books_statistics/books_statistics_controller.dart';
import 'package:app/modules/statistics/elements/books_statistics/books_status_dropdown_form_field.dart';
import 'package:app/widgets/charts/doughnut_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BooksStatistics extends StatelessWidget {
  const BooksStatistics();

  @override
  Widget build(BuildContext context) {
    BooksStatisticsController controller = BooksStatisticsController(
      bookQuery: context.read<BookQuery>(),
      bookCategoryService: BookCategoryService(),
    );

    return StreamBuilder(
      stream: controller.categoriesData$,
      builder: (_, AsyncSnapshot<List<DoughnutChartData>> snapshot) {
        List<DoughnutChartData>? chartData = snapshot.data;
        if (chartData != null) {
          return Column(
            children: [
              Text('Książki', style: Theme.of(context).textTheme.headline6),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: BooksStatusDropdownFormField(
                  onChanged: (StatsBooksStatus status) {
                    controller.setNewBooksStatus(status);
                  },
                ),
              ),
              SizedBox(height: 8),
              Stack(
                children: [
                  DoughnutChart(chartData: chartData, displayLegend: true),
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(top: 104),
                      child: _BooksAmountText(
                        amount$: controller.matchingBooksAmount$,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        }
        return Text('No chart data');
      },
    );
  }
}

class _BooksAmountText extends StatelessWidget {
  final Stream<int> amount$;

  const _BooksAmountText({required this.amount$});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: amount$,
      builder: (_, AsyncSnapshot<int> snapshot) {
        int? allBooksAmount = snapshot.data;
        if (allBooksAmount != null) {
          return Column(
            children: [
              Text(
                'Łącznie:',
                style: Theme.of(context).textTheme.subtitle1,
              ),
              SizedBox(height: 4),
              Text(
                '$allBooksAmount',
                style: Theme.of(context).textTheme.headline6,
              ),
            ],
          );
        }
        return SizedBox(height: 0);
      },
    );
  }
}
