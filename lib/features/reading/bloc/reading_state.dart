part of 'reading_bloc.dart';

class ReadingState extends BlocState {
  final List<Book> booksInProgress;

  const ReadingState({
    required super.status,
    required this.booksInProgress,
  });

  @override
  List<Object> get props => [status, booksInProgress];

  ReadingState copyWith({
    BlocStatus? status,
    List<Book>? booksInProgress,
  }) {
    return ReadingState(
      status: status ?? const BlocStatusComplete(),
      booksInProgress: booksInProgress ?? this.booksInProgress,
    );
  }
}
