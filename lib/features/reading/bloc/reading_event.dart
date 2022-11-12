part of 'reading_bloc.dart';

abstract class ReadingEvent {
  const ReadingEvent();
}

class ReadingEventInitialize extends ReadingEvent {
  const ReadingEventInitialize();
}

class ReadingEventBooksInProgressUpdated extends ReadingEvent {
  final List<Book>? booksInProgress;

  const ReadingEventBooksInProgressUpdated({required this.booksInProgress});
}
