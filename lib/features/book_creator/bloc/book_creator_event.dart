part of 'book_creator_bloc.dart';

abstract class BookCreatorEvent {
  const BookCreatorEvent();
}

class BookCreatorEventChangeImagePath extends BookCreatorEvent {
  final String imagePath;

  const BookCreatorEventChangeImagePath({required this.imagePath});
}

class BookCreatorEventRemoveImage extends BookCreatorEvent {
  const BookCreatorEventRemoveImage();
}

class BookCreatorEventTitleChanged extends BookCreatorEvent {
  final String title;

  const BookCreatorEventTitleChanged({required this.title});
}

class BookCreatorEventAuthorChanged extends BookCreatorEvent {
  final String author;

  const BookCreatorEventAuthorChanged({required this.author});
}

class BookCreatorEventReadPagesAmountChanged extends BookCreatorEvent {
  final int readPagesAmount;

  const BookCreatorEventReadPagesAmountChanged({required this.readPagesAmount});
}

class BookCreatorEventAllPagesAmountChanged extends BookCreatorEvent {
  final int allPagesAmount;

  const BookCreatorEventAllPagesAmountChanged({required this.allPagesAmount});
}

class BookCreatorEventSubmit extends BookCreatorEvent {
  const BookCreatorEventSubmit();
}
