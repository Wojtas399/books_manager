import 'dart:async';
import 'dart:typed_data';

import 'package:app/config/errors.dart';
import 'package:app/domain/entities/book.dart';
import 'package:app/domain/use_cases/book/delete_book_use_case.dart';
import 'package:app/domain/use_cases/book/get_book_by_id_use_case.dart';
import 'package:app/domain/use_cases/book/start_reading_book_use_case.dart';
import 'package:app/domain/use_cases/book/update_current_page_number_in_book_use_case.dart';
import 'package:app/models/bloc_state.dart';
import 'package:app/models/bloc_status.dart';
import 'package:app/models/error.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'book_preview_event.dart';
part 'book_preview_state.dart';

class BookPreviewBloc extends Bloc<BookPreviewEvent, BookPreviewState> {
  late final GetBookByIdUseCase _getBookByIdUseCase;
  late final StartReadingBookUseCase _startReadingBookUseCase;
  late final UpdateCurrentPageNumberInBookUseCase
      _updateCurrentPageNumberInBookUseCase;
  late final DeleteBookUseCase _deleteBookUseCase;
  StreamSubscription<Book>? _bookListener;

  BookPreviewBloc({
    required GetBookByIdUseCase getBookByIdUseCase,
    required StartReadingBookUseCase startReadingBookUseCase,
    required UpdateCurrentPageNumberInBookUseCase
        updateCurrentPageNumberInBookUseCase,
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
    _startReadingBookUseCase = startReadingBookUseCase;
    _updateCurrentPageNumberInBookUseCase =
        updateCurrentPageNumberInBookUseCase;
    _deleteBookUseCase = deleteBookUseCase;
    on<BookPreviewEventInitialize>(_initialize);
    on<BookPreviewEventBookUpdated>(_bookUpdated);
    on<BookPreviewEventStartReading>(_startReading);
    on<BookPreviewEventUpdateCurrentPageNumber>(_updateCurrentPageNumber);
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

  Future<void> _startReading(
    BookPreviewEventStartReading event,
    Emitter<BookPreviewState> emit,
  ) async {
    final String? bookId = state.bookId;
    if (bookId != null) {
      emit(state.copyWith(
        status: const BlocStatusLoading(),
      ));
      await _startReadingBookUseCase.execute(
        bookId: bookId,
        fromBeginning: event.fromBeginning,
      );
      emit(state.copyWith(
        status: const BlocStatusComplete(),
      ));
    }
  }

  Future<void> _updateCurrentPageNumber(
    BookPreviewEventUpdateCurrentPageNumber event,
    Emitter<BookPreviewState> emit,
  ) async {
    final String? bookId = state.bookId;
    if (bookId != null) {
      emit(state.copyWith(
        status: const BlocStatusLoading(),
      ));
      try {
        await _updateCurrentPageNumberInBookUseCase.execute(
          bookId: bookId,
          newCurrentPageNumber: event.currentPageNumber,
        );
        emit(state.copyWithInfo(
          BookPreviewBlocInfo.currentPageNumberHasBeenUpdated,
        ));
      } on BookError catch (bookError) {
        _manageBookError(bookError, emit);
      }
    }
  }

  Future<void> _deleteBook(
    BookPreviewEventDeleteBook event,
    Emitter<BookPreviewState> emit,
  ) async {
    final String? bookId = state.bookId;
    if (bookId != null) {
      emit(state.copyWith(
        status: const BlocStatusLoading(),
      ));
      await _deleteBookUseCase.execute(bookId: bookId);
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

  void _manageBookError(BookError bookError, Emitter<BookPreviewState> emit) {
    if (bookError.code == BookErrorCode.newCurrentPageIsTooHigh) {
      emit(state.copyWithError(
        BookPreviewBlocError.newCurrentPageNumberIsTooHigh,
      ));
    }
  }
}
