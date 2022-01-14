import 'package:equatable/equatable.dart';
import 'package:app/core/book/book_model.dart';

abstract class BookDetailsActions extends Equatable {}

class BookDetailsActionsPauseReading extends BookDetailsActions {
  BookDetailsActionsPauseReading();

  @override
  List<Object> get props => [];
}

class BookDetailsActionsStartReading extends BookDetailsActions {
  BookDetailsActionsStartReading();

  @override
  List<Object> get props => [];
}

class BookDetailsActionsDeletedBook extends BookDetailsActions {
  BookDetailsActionsDeletedBook();

  @override
  List<Object> get props => [];
}

class BookDetailsActionsUpdateImg extends BookDetailsActions {
  final String newImgPath;

  BookDetailsActionsUpdateImg({required this.newImgPath});

  @override
  List<Object> get props => [newImgPath];
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

  @override
  List<Object> get props => [
        author ?? '',
        title ?? '',
        category ?? '',
        pages ?? '',
        readPages ?? '',
        status ?? '',
      ];
}
