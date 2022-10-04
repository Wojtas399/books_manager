part of 'day_preview_bloc.dart';

class DayPreviewState extends BlocState {
  final List<DayPreviewReadBook> dayPreviewReadBooks;

  const DayPreviewState({
    required super.status,
    required this.dayPreviewReadBooks,
  });

  @override
  List<Object> get props => [
        status,
        dayPreviewReadBooks,
      ];

  DayPreviewState copyWith({
    BlocStatus? status,
    List<DayPreviewReadBook>? dayPreviewReadBooks,
  }) {
    return DayPreviewState(
      status: status ?? const BlocStatusComplete(),
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
