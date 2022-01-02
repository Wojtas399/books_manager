import 'package:app/core/book/book_bloc.dart';
import 'package:app/core/book/book_model.dart';
import 'package:app/core/book/book_query.dart';
import 'package:app/core/services/book_category_service.dart';
import 'package:app/modules/book_details/bloc/book_details_actions.dart';
import 'package:app/modules/book_details/bloc/book_details_query.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookDetailsBloc extends Bloc<BookDetailsActions, BookDetailsQuery> {
  final String bookId;
  final BookQuery bookQuery;
  final BookBloc bookBloc;
  final BookCategoryService bookCategoryService;

  BookDetailsBloc({
    required this.bookId,
    required this.bookQuery,
    required this.bookBloc,
    required this.bookCategoryService,
  }) : super(BookDetailsQuery(
          bookQuery: bookQuery,
          bookId: bookId,
          bookCategoryService: bookCategoryService,
        ));

  @override
  Stream<BookDetailsQuery> mapEventToState(BookDetailsActions event) async* {
    if (event is BookDetailsActionsPauseReading) {
      _pauseReading();
    } else if (event is BookDetailsActionsStartReading) {
      _startReading();
    } else if (event is BookDetailsActionsDeletedBook) {
      _deleteBook();
    } else if (event is BookDetailsActionsUpdateImg) {
      _updateImg(event.newImgPath);
    } else if (event is BookDetailsActionsUpdateBook) {
      _updateBook(
        event.author,
        event.title,
        event.category,
        event.pages,
        event.readPages,
        event.status,
      );
    }
  }

  _pauseReading() {
    this.bookBloc.updateBook(bookId: bookId, status: BookStatus.paused);
  }

  _startReading() {
    this.bookBloc.updateBook(bookId: bookId, status: BookStatus.read);
  }

  _deleteBook() {
    this.bookBloc.deleteBook(bookId: bookId);
  }

  _updateImg(String imgPath) {
    this.bookBloc.updateBookImg(bookId: bookId, newImgPath: imgPath);
  }

  _updateBook(
    String? author,
    String? title,
    BookCategory? category,
    int? pages,
    int? readPages,
    BookStatus? status,
  ) {
    this.bookBloc.updateBook(
          bookId: bookId,
          author: author,
          title: title,
          category: category,
          pages: pages,
          readPages: readPages,
          status: status,
        );
  }
}
