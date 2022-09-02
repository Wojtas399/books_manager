part of 'library_bloc.dart';

abstract class LibraryEvent {
  const LibraryEvent();
}

class LibraryEventInitialize extends LibraryEvent {
  const LibraryEventInitialize();
}

class LibraryEventBooksUpdated extends LibraryEvent {
  final List<Book> books;

  const LibraryEventBooksUpdated({required this.books});
}
