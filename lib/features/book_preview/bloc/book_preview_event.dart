part of 'book_preview_bloc.dart';

abstract class BookPreviewEvent {
  const BookPreviewEvent();
}

class BookPreviewEventInitialize extends BookPreviewEvent {
  final String bookId;

  const BookPreviewEventInitialize({required this.bookId});
}
