import 'package:app/core/book/book_query.dart';
import 'package:app/core/day/day_query.dart';
import 'package:app/modules/calendar/elements/day_info/day_info_book_item.dart';
import 'package:app/modules/calendar/elements/day_info/day_info_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DayInfo extends StatelessWidget {
  final String dayId;

  const DayInfo({required this.dayId});

  @override
  Widget build(BuildContext context) {
    DayInfoController controller = DayInfoController(
      dayId: dayId,
      dayQuery: context.read<DayQuery>(),
      bookQuery: context.read<BookQuery>(),
    );

    // return SlidingUpPanel(
    //   borderRadius: BorderRadius.only(
    //     topLeft: Radius.circular(24.0),
    //     topRight: Radius.circular(24.0),
    //   ),
    //   minHeight: 96,
    //   header: Container(
    //     width: 390,
    //     child: Column(
    //       children: [
    //         Icon(Icons.drag_handle_rounded),
    //         SizedBox(height: 8),
    //         _ShortInfo(dayId: dayId, booksAmount$: controller.booksAmount$),
    //       ],
    //     ),
    //   ),
    //   panel: _Panel(books$: controller.dayInfo$),
    // );

    return SizedBox();
  }
}

class _ShortInfo extends StatelessWidget {
  final String dayId;
  final Stream<int> booksAmount$;

  const _ShortInfo({required this.dayId, required this.booksAmount$});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: booksAmount$,
      builder: (_, AsyncSnapshot<int> snapshot) {
        int? booksAmount = snapshot.data;
        if (booksAmount != null) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _ShortInfoItem(date: dayId, booksAmount: booksAmount),
                ],
              ),
            ],
          );
        }
        return SizedBox(height: 0);
      },
    );
  }
}

class _Panel extends StatelessWidget {
  final Stream<List<DayBookInfo>> books$;

  const _Panel({required this.books$});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: books$,
      builder: (_, AsyncSnapshot<List<DayBookInfo>> snapshot) {
        List<DayBookInfo>? books = snapshot.data;
        if (books != null && books.length > 0) {
          return Padding(
            padding: EdgeInsets.only(top: 96.0, left: 16.0, right: 16.0),
            child: SingleChildScrollView(
              child: Column(
                children: books
                    .map((book) => DayInfoBookItem(bookInfo: book))
                    .toList(),
              ),
            ),
          );
        }
        return Center(
          child: Text('Brak czytanych książek'),
        );
      },
    );
  }
}

class _ShortInfoItem extends StatelessWidget {
  final String date;
  final int booksAmount;

  const _ShortInfoItem({required this.date, required this.booksAmount});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(date, style: Theme.of(context).textTheme.headline6),
        SizedBox(height: 4),
        Text(
          'Liczba książek: $booksAmount',
          style: Theme.of(context).textTheme.subtitle1,
        ),
      ],
    );
  }
}
