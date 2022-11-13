part of 'day_preview_bloc.dart';

class DayPreviewState extends BlocState {
  final DateTime? date;
  final List<DayPreviewBook> dayPreviewBooks;

  const DayPreviewState({
    required super.status,
    required this.date,
    required this.dayPreviewBooks,
  });

  @override
  List<Object> get props => [
        status,
        date ?? '',
        dayPreviewBooks,
      ];

  @override
  DayPreviewState copyWith({
    BlocStatus? status,
    DateTime? date,
    List<DayPreviewBook>? dayPreviewBooks,
  }) {
    return DayPreviewState(
      status: status ?? const BlocStatusComplete(),
      date: date ?? this.date,
      dayPreviewBooks: dayPreviewBooks ?? this.dayPreviewBooks,
    );
  }
}

class DayPreviewBook extends Equatable {
  final String id;
  final Uint8List? imageData;
  final String title;
  final String author;
  final int amountOfPagesReadInThisDay;

  const DayPreviewBook({
    required this.id,
    required this.imageData,
    required this.title,
    required this.author,
    required this.amountOfPagesReadInThisDay,
  });

  @override
  List<Object> get props => [
        id,
        imageData ?? '',
        title,
        author,
        amountOfPagesReadInThisDay,
      ];
}

DayPreviewBook createDayPreviewBook({
  String id = '',
  Uint8List? imageData,
  String title = '',
  String author = '',
  int amountOfPagesReadInThisDay = 0,
}) {
  return DayPreviewBook(
    id: id,
    imageData: imageData,
    title: title,
    author: author,
    amountOfPagesReadInThisDay: amountOfPagesReadInThisDay,
  );
}
