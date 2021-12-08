import 'package:app/core/book/book_model.dart';
import 'package:app/core/book/book_query.dart';
import 'package:rxdart/rxdart.dart';

class HomeQuery {
  late BookQuery _bookQuery;

  HomeQuery({required BookQuery bookQuery}) {
    _bookQuery = bookQuery;
  }

  Stream<List<String>> get booksIds$ =>
      _bookQuery.selectIdsByStatuses([BookStatus.read]);

  Stream<List<BookCategory>> get booksCategories$ => booksIds$.flatMap(
        (booksIds) => Rx.combineLatest(
            booksIds.map((id) => _bookQuery.selectCategory(id)),
            (values) => values as List<BookCategory>),
      );

  Stream<int> get booksReadPages$ =>
      booksIds$.flatMap((booksIds) => Rx.combineLatest(
            booksIds.map((id) => _bookQuery.selectReadPages(id)),
            (values) => values as List<int>,
          ).map(
            (readPages) =>
                readPages.reduce((value, element) => value + element),
          ));

  Stream<int> get booksAllPages$ => booksIds$.flatMap(
        (booksIds) => Rx.combineLatest(
          booksIds.map((id) => _bookQuery.selectPages(id)),
          (values) => values as List<int>,
        ).map(
          (allPages) => allPages.reduce((value, element) => value + element),
        ),
      );
}
