part of 'day_preview_bloc.dart';

abstract class DayPreviewEvent {
  const DayPreviewEvent();
}

class DayPreviewEventInitialize extends DayPreviewEvent {
  final List<ReadBook> readBooks;

  const DayPreviewEventInitialize({required this.readBooks});
}
