import 'package:app/core/book/book_model.dart';

abstract class BookDetailsActions {}

class BookDetailsActionsPauseReading extends BookDetailsActions {
  BookDetailsActionsPauseReading();
}

class BookDetailsActionsStartReading extends BookDetailsActions {
  BookDetailsActionsStartReading();
}

class BookDetailsActionsDeletedBook extends BookDetailsActions {
  BookDetailsActionsDeletedBook();
}

class BookDetailsActionsUpdateImg extends BookDetailsActions {
  final String newImgPath;

  BookDetailsActionsUpdateImg({required this.newImgPath});
}

class BookDetailsActionsUpdateBook extends BookDetailsActions {
  final String? author;
  final String? title;
  final BookCategory? category;
  final int? pages;
  final int? readPages;
  final BookStatus? status;

  BookDetailsActionsUpdateBook({
    this.author,
    this.title,
    this.category,
    this.pages,
    this.readPages,
    this.status,
  });
}
