import 'package:app/core/book/book_query.dart';
import 'package:app/core/day/day_query.dart';
import 'package:rxdart/rxdart.dart';

class DayInfoController {
  late String _dayId;
  late DayQuery _dayQuery;
  late BookQuery _bookQuery;

  DayInfoController({
    required String dayId,
    required DayQuery dayQuery,
    required BookQuery bookQuery,
  }) {
    _dayId = dayId;
    _dayQuery = dayQuery;
    _bookQuery = bookQuery;
  }

  Stream<List<String>> get _booksIds$ => _dayQuery.selectBooksIds(_dayId);

  Stream<List<String>> get _titles$ =>
      _booksIds$.flatMap((booksIds) => booksIds.length == 0
          ? Stream.value([])
          : Rx.combineLatest(
              booksIds.map((bookId) => _bookQuery.selectTitle(bookId)),
              (titles) => titles as List<String>));

  Stream<List<int>> get _readPages$ => _booksIds$
      .flatMap((booksIds) => booksIds.length == 0
          ? Stream.value([])
          : Rx.combineLatest(
              booksIds
                  .map((bookId) => _dayQuery.selectReadPages(_dayId, bookId)),
              (readPages) => readPages as List<int?>))
      .map((readPages) => readPages.length > 0
          ? readPages.map((amount) => amount is int ? amount : 0).toList()
          : []);

  Stream<List<DayBookInfo>> get dayInfo$ => Rx.combineLatest2(
        _titles$,
        _readPages$,
        (List<String> titles, List<int> readPages) {
          return List.generate(
            titles.length,
            (index) => DayBookInfo(
              title: titles[index],
              readPages: readPages[index],
            ),
          );
        },
      );

  Stream<int> get booksAmount$ => _booksIds$.map((booksIds) => booksIds.length);
}

class DayBookInfo {
  String title;
  int readPages;

  DayBookInfo({required this.title, required this.readPages});
}
