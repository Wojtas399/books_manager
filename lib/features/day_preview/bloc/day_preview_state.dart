part of 'day_preview_bloc.dart';

class DayPreviewState extends BlocState {
  final DateTime? date;
  final List<DayPreviewReadBook> dayPreviewReadBooks;

  const DayPreviewState({
    required super.status,
    required this.date,
    required this.dayPreviewReadBooks,
  });

  @override
  List<Object> get props => [
        status,
        date ?? '',
        dayPreviewReadBooks,
      ];

  DayPreviewState copyWith({
    BlocStatus? status,
    DateTime? date,
    List<DayPreviewReadBook>? dayPreviewReadBooks,
  }) {
    return DayPreviewState(
      status: status ?? const BlocStatusComplete(),
      date: date ?? this.date,
      dayPreviewReadBooks: dayPreviewReadBooks ?? this.dayPreviewReadBooks,
    );
  }
}

class DayPreviewReadBook extends Equatable {
  final String bookId;
  final Uint8List? imageData;
  final String title;
  final String author;
  final int amountOfPagesReadInThisDay;

  const DayPreviewReadBook({
    required this.bookId,
    required this.imageData,
    required this.title,
    required this.author,
    required this.amountOfPagesReadInThisDay,
  });

  @override
  List<Object> get props => [
        bookId,
        imageData ?? '',
        title,
        author,
        amountOfPagesReadInThisDay,
      ];
}

DayPreviewReadBook createDayPreviewReadBook({
  String bookId = '',
  Uint8List? imageData,
  String title = '',
  String author = '',
  int amountOfPagesReadInThisDay = 0,
}) {
  return DayPreviewReadBook(
    bookId: bookId,
    imageData: imageData,
    title: title,
    author: author,
    amountOfPagesReadInThisDay: amountOfPagesReadInThisDay,
  );
}
