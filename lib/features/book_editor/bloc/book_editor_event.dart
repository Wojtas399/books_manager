part of 'book_editor_bloc.dart';

abstract class BookEditorEvent {
  const BookEditorEvent();
}

class BookEditorEventInitialize extends BookEditorEvent {
  final String bookId;

  const BookEditorEventInitialize({required this.bookId});
}

class BookEditorEventImageChanged extends BookEditorEvent {
  final ImageFile? imageFile;

  const BookEditorEventImageChanged({required this.imageFile});
}

class BookEditorEventRestoreOriginalImage extends BookEditorEvent {
  const BookEditorEventRestoreOriginalImage();
}

class BookEditorEventTitleChanged extends BookEditorEvent {
  final String title;

  const BookEditorEventTitleChanged({required this.title});
}

class BookEditorEventAuthorChanged extends BookEditorEvent {
  final String author;

  const BookEditorEventAuthorChanged({required this.author});
}

class BookEditorEventReadPagesAmountChanged extends BookEditorEvent {
  final int readPagesAmount;

  const BookEditorEventReadPagesAmountChanged({required this.readPagesAmount});
}

class BookEditorEventAllPagesAmountChanged extends BookEditorEvent {
  final int allPagesAmount;

  const BookEditorEventAllPagesAmountChanged({required this.allPagesAmount});
}

class BookEditorEventSubmit extends BookEditorEvent {
  const BookEditorEventSubmit();
}
