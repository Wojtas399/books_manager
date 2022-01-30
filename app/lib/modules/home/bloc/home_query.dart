import 'package:app/core/book/book_model.dart';
import 'package:app/core/book/book_query.dart';
import 'package:equatable/equatable.dart';
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

  Stream<int> get readPages$ => booksIds$.flatMap(
        (booksIds) => Rx.combineLatest(
          booksIds.map((id) => _bookQuery.selectReadPages(id)),
          (values) => values as List<int>,
        ).map(
          (readPages) => readPages.reduce((value, element) => value + element),
        ),
      );

  Stream<int> get allPages$ => booksIds$.flatMap(
        (booksIds) => Rx.combineLatest(
          booksIds.map((id) => _bookQuery.selectPages(id)),
          (values) => values as List<int>,
        ).map(
          (allPages) => allPages.reduce((value, element) => value + element),
        ),
      );

  Stream<BookItemDetails> selectBookItemDetails(String bookId) {
    return _bookQuery.selectDetails(bookId).map(
          (details) => BookItemDetails(
            title: details.title,
            author: details.author,
            readPages: details.readPages,
            pages: details.pages,
            imgUrl: details.imgUrl,
          ),
        );
  }
}

class BookItemDetails extends Equatable {
  final String title;
  final String author;
  final int readPages;
  final int pages;
  final String imgUrl;

  BookItemDetails({
    required this.title,
    required this.author,
    required this.readPages,
    required this.pages,
    required this.imgUrl,
  });

  @override
  List<Object> get props => [
        title,
        author,
        readPages,
        pages,
        imgUrl,
      ];
}
