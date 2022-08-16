import 'package:app/core/book/book_model.dart';
import 'package:app/core/book/book_query.dart';
import 'package:app/core/services/book_category_service.dart';
import 'package:rxdart/rxdart.dart';
import '../book_details_model.dart';

class BookDetailsQuery {
  late String _bookId;
  late BookQuery _bookQuery;
  late BookCategoryService _bookCategoryService;

  BookDetailsQuery({
    required String bookId,
    required BookQuery bookQuery,
    required BookCategoryService bookCategoryService,
  }) {
    _bookId = bookId;
    _bookQuery = bookQuery;
    _bookCategoryService = bookCategoryService;
  }

  Stream<String> get title$ => _bookQuery.selectTitle(_bookId);

  Stream<BookCategory> get category$ => _bookQuery.selectCategory(_bookId);

  Stream<BookStatus> get status$ => _bookQuery.selectStatus(_bookId);

  Stream<BookDetailsModel> get bookDetails$ => Rx.combineLatest9(
        title$,
        _bookQuery.selectAuthor(_bookId),
        category$,
        _bookQuery.selectImgUrl(_bookId),
        _bookQuery.selectReadPages(_bookId),
        _bookQuery.selectPages(_bookId),
        status$,
        _bookQuery.selectLastActualisationDate(_bookId),
        _bookQuery.selectAddDate(_bookId),
        (
          String title,
          String author,
          BookCategory category,
          String imgUrl,
          int readPages,
          int pages,
          BookStatus status,
          String lastActualisationDate,
          String addDate,
        ) =>
            BookDetailsModel(
          title: title,
          author: author,
          category: _bookCategoryService.convertCategoryToText(category),
          imgUrl: imgUrl,
          readPages: readPages,
          pages: pages,
          status: _convertStatusFromEnumToString(status),
          lastActualisation: lastActualisationDate,
          addDate: addDate,
        ),
      );

  String _convertStatusFromEnumToString(BookStatus status) {
    switch (status) {
      case BookStatus.pending:
        return 'Oczekująca';
      case BookStatus.read:
        return 'W trakcie czytania';
      case BookStatus.end:
        return 'Przeczytana';
      case BookStatus.paused:
        return 'Wstrzymana';
    }
  }
}
