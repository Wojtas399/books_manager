import 'dart:async';
import 'dart:typed_data';

import 'package:app/domain/entities/book.dart';
import 'package:app/domain/use_cases/book/delete_book_use_case.dart';
import 'package:app/domain/use_cases/book/get_book_by_id_use_case.dart';
import 'package:app/models/bloc_state.dart';
import 'package:app/models/bloc_status.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'book_preview_event.dart';
part 'book_preview_state.dart';

class BookPreviewBloc extends Bloc<BookPreviewEvent, BookPreviewState> {
  late final GetBookByIdUseCase _getBookByIdUseCase;
  late final DeleteBookUseCase _deleteBookUseCase;
  StreamSubscription<Book>? _bookListener;

  BookPreviewBloc({
    required GetBookByIdUseCase getBookByIdUseCase,
    required DeleteBookUseCase deleteBookUseCase,
    BlocStatus status = const BlocStatusInitial(),
    Book? book,
  }) : super(
          BookPreviewState(
            status: status,
            book: book,
          ),
        ) {
    _getBookByIdUseCase = getBookByIdUseCase;
    _deleteBookUseCase = deleteBookUseCase;
    on<BookPreviewEventInitialize>(_initialize);
    on<BookPreviewEventBookUpdated>(_bookUpdated);
    on<BookPreviewEventDeleteBook>(_deleteBook);
  }

  @override
  Future<void> close() async {
    super.close();
    _bookListener?.cancel();
  }

  void _initialize(
    BookPreviewEventInitialize event,
    Emitter<BookPreviewState> emit,
  ) {
    emit(state.copyWith(
      status: const BlocStatusLoading(),
    ));
    _setBookListener(event.bookId);
  }

  void _bookUpdated(
    BookPreviewEventBookUpdated event,
    Emitter<BookPreviewState> emit,
  ) {
    emit(state.copyWith(
      status: const BlocStatusComplete(),
      book: event.book,
    ));
  }

  Future<void> _deleteBook(
    BookPreviewEventDeleteBook event,
    Emitter<BookPreviewState> emit,
  ) async {
    final String? bookId = state._book?.id;
    final String? userId = state._book?.userId;
    if (bookId != null && userId != null) {
      emit(state.copyWith(
        status: const BlocStatusLoading(),
      ));
      await _deleteBookUseCase.execute(userId: userId, bookId: bookId);
      emit(state.copyWithInfo(
        BookPreviewBlocInfo.bookHasBeenDeleted,
      ));
    }
  }

  void _setBookListener(String bookId) {
    _bookListener ??= _getBookByIdUseCase
        .execute(bookId: bookId)
        .listen((Book book) => add(BookPreviewEventBookUpdated(book: book)));
  }
}
