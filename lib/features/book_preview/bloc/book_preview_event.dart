part of 'book_preview_bloc.dart';

abstract class BookPreviewEvent {
  const BookPreviewEvent();
}

class BookPreviewEventInitialize extends BookPreviewEvent {
  final String bookId;

  const BookPreviewEventInitialize({required this.bookId});
}

class BookPreviewEventBookUpdated extends BookPreviewEvent {
  final Book book;

  const BookPreviewEventBookUpdated({required this.book});
}

class BookPreviewEventStartReading extends BookPreviewEvent {
  final bool fromBeginning;

  const BookPreviewEventStartReading({this.fromBeginning = false});
}

class BookPreviewEventUpdateCurrentPageNumber extends BookPreviewEvent {
  final int currentPageNumber;

  const BookPreviewEventUpdateCurrentPageNumber({
    required this.currentPageNumber,
  });
}

class BookPreviewEventDeleteBook extends BookPreviewEvent {
  const BookPreviewEventDeleteBook();
}
