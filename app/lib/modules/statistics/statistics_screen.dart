import 'package:app/modules/statistics/elements/books_statistics/books_statistics.dart';
import 'package:app/modules/statistics/elements/read_pages_statistics/read_pages_statistics_chart.dart';
import 'package:flutter/material.dart';
import 'elements/read_books_statistics/read_books_statistics_chart.dart';

class StatisticsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            BooksStatistics(),
            SizedBox(height: 16),
            ReadPagesStatisticsChart(),
            SizedBox(height: 16),
            ReadBooksStatisticsChart(),
          ],
        ),
      ),
    );
  }
}
