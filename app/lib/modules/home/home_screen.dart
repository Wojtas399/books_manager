import 'package:app/core/book/book_model.dart';
import 'package:app/core/book/book_query.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'elements/book_item/book_item.dart';
import 'elements/statistics/read_books_stats_charts.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    BookQuery bookQuery = Provider.of<BookQuery>(context);

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(8),
        width: double.infinity,
        child: StreamBuilder(
          stream: bookQuery.selectIdsByStatuses([BookStatus.read]),
          builder: (_, AsyncSnapshot<List<String>> snapshot) {
            List<String>? booksIds = snapshot.data;
            if (booksIds != null) {
              return Column(
                children: [
                  SizedBox(height: 8),
                  Text(
                    'Aktualnie czytane książki',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  SizedBox(height: 8),
                  ...booksIds.map((bookId) => BookItem(bookId: bookId)),
                  SizedBox(height: 8),
                  ReadBooksStatsCharts(booksIds: booksIds),
                  SizedBox(height: 8),
                ],
              );
            } else {
              return Text('brak');
            }
          },
        ),
      ),
    );
  }
}
