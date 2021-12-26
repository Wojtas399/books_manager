import 'package:app/core/book/book_model.dart';
import 'package:app/core/book/book_query.dart';
import '../library_screen_controller.dart';
import 'package:rxdart/rxdart.dart';

class LibraryQuery {
  late BookQuery _bookQuery;

  LibraryQuery({required BookQuery bookQuery}) {
    _bookQuery = bookQuery;
  }

  Stream<List<BookInfo>> get allBooksInfo$ => _bookQuery
      .selectAllIds()
      .map((allBooksIds) => allBooksIds
          .map(
            (id) => Rx.combineLatest5(
              _bookQuery.selectTitle(id),
              _bookQuery.selectAuthor(id),
              _bookQuery.selectStatus(id),
              _bookQuery.selectCategory(id),
              _bookQuery.selectPages(id),
              (
                String title,
                String author,
                BookStatus status,
                BookCategory category,
                int pages,
              ) =>
                  BookInfo(
                id: id,
                title: title,
                author: author,
                status: status,
                category: category,
                pages: pages,
              ),
            ),
          )
          .toList())
      .flatMap((streams) => Rx.combineLatest(
            streams,
            (values) => values as List<BookInfo>,
          ));
}
