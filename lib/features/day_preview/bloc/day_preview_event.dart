part of 'day_preview_bloc.dart';

abstract class DayPreviewEvent {
  const DayPreviewEvent();
}

class DayPreviewEventInitialize extends DayPreviewEvent {
  final DateTime date;
  final List<ReadBook> readBooks;

  const DayPreviewEventInitialize({
    required this.date,
    required this.readBooks,
  });
}
