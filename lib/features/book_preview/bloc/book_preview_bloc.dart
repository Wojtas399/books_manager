import 'dart:async';
import 'dart:typed_data';

import 'package:app/config/errors.dart';
import 'package:app/domain/entities/book.dart';
import 'package:app/domain/use_cases/auth/get_logged_user_id_use_case.dart';
import 'package:app/domain/use_cases/book/delete_book_use_case.dart';
import 'package:app/domain/use_cases/book/get_book_use_case.dart';
import 'package:app/domain/use_cases/book/start_reading_book_use_case.dart';
import 'package:app/domain/use_cases/book/update_current_page_number_after_reading_use_case.dart';
import 'package:app/models/bloc_state.dart';
import 'package:app/models/bloc_status.dart';
import 'package:app/models/custom_bloc.dart';
import 'package:app/models/error.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

part 'book_preview_event.dart';
part 'book_preview_state.dart';

class BookPreviewBloc extends CustomBloc<BookPreviewEvent, BookPreviewState> {
  late final GetLoggedUserIdUseCase _getLoggedUserIdUseCase;
  late final GetBookUseCase _getBookUseCase;
  late final StartReadingBookUseCase _startReadingBookUseCase;
  late final UpdateCurrentPageNumberAfterReadingUseCase
      _updateCurrentPageNumberAfterReadingUseCase;
  late final DeleteBookUseCase _deleteBookUseCase;
  StreamSubscription<Book?>? _bookListener;

  BookPreviewBloc({
    required GetLoggedUserIdUseCase getLoggedUserIdUseCase,
    required GetBookUseCase getBookUseCase,
    required StartReadingBookUseCase startReadingBookUseCase,
    required UpdateCurrentPageNumberAfterReadingUseCase
        updateCurrentPageNumberAfterReadingUseCase,
    required DeleteBookUseCase deleteBookUseCase,
    required String bookId,
    BlocStatus status = const BlocStatusInitial(),
    Uint8List? initialBookImageData,
    Book? book,
  }) : super(
          BookPreviewState(
            status: status,
            bookId: bookId,
            initialBookImageData: initialBookImageData,
            book: book,
          ),
        ) {
    _getLoggedUserIdUseCase = getLoggedUserIdUseCase;
    _getBookUseCase = getBookUseCase;
    _startReadingBookUseCase = startReadingBookUseCase;
    _updateCurrentPageNumberAfterReadingUseCase =
        updateCurrentPageNumberAfterReadingUseCase;
    _deleteBookUseCase = deleteBookUseCase;
    on<BookPreviewEventInitialize>(_initialize);
    on<BookPreviewEventBookUpdated>(_bookUpdated);
    on<BookPreviewEventStartReading>(_startReading);
    on<BookPreviewEventUpdateCurrentPageNumber>(_updateCurrentPageNumber);
    on<BookPreviewEventDeleteBook>(_deleteBook);
  }

  @override
  Future<void> close() {
    _bookListener?.cancel();
    return super.close();
  }

  Future<void> _initialize(
    BookPreviewEventInitialize event,
    Emitter<BookPreviewState> emit,
  ) async {
    emitLoadingStatus(emit);
    _bookListener ??= _getLoggedUserIdUseCase
        .execute()
        .switchMap(
          (String? loggedUserId) => _getBook(event.bookId, loggedUserId),
        )
        .listen(
          (Book? book) => add(
            BookPreviewEventBookUpdated(book: book),
          ),
        );
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
    final String? userId = state._book?.userId;
    if (userId == null) {
      return;
    }
    emitLoadingStatus(emit);
    await _startReadingBookUseCase.execute(
      bookId: state.bookId,
      userId: userId,
      fromBeginning: event.fromBeginning,
    );
    emit(state.copyWith(
      status: const BlocStatusComplete(),
    ));
  }

  Future<void> _updateCurrentPageNumber(
    BookPreviewEventUpdateCurrentPageNumber event,
    Emitter<BookPreviewState> emit,
  ) async {
    emitLoadingStatus(emit);
    final String? loggedUserId = await _getLoggedUserIdUseCase.execute().first;
    if (loggedUserId == null) {
      emitLoggedUserNotFoundStatus(emit);
      return;
    }
    try {
      await _updateCurrentPageNumberAfterReadingUseCase.execute(
        userId: loggedUserId,
        bookId: state.bookId,
        newCurrentPageNumber: event.currentPageNumber,
      );
      emitInfo<BookPreviewBlocInfo>(
        emit,
        BookPreviewBlocInfo.currentPageNumberHasBeenUpdated,
      );
    } on BookError catch (bookError) {
      _manageBookError(bookError, emit);
    }
  }

  Future<void> _deleteBook(
    BookPreviewEventDeleteBook event,
    Emitter<BookPreviewState> emit,
  ) async {
    emitLoadingStatus(emit);
    final String? loggedUserId = await _getLoggedUserIdUseCase.execute().first;
    if (loggedUserId == null) {
      emitLoggedUserNotFoundStatus(emit);
      return;
    }
    await _deleteBookUseCase.execute(
      bookId: state.bookId,
      userId: loggedUserId,
    );
    emitInfo<BookPreviewBlocInfo>(emit, BookPreviewBlocInfo.bookHasBeenDeleted);
  }

  Stream<Book?> _getBook(String bookId, String? userId) {
    if (userId == null) {
      return Stream.value(null);
    }
    return _getBookUseCase.execute(bookId: bookId, userId: userId);
  }

  void _manageBookError(BookError bookError, Emitter<BookPreviewState> emit) {
    if (bookError.code == BookErrorCode.newCurrentPageIsTooHigh) {
      emitError<BookPreviewBlocError>(
        emit,
        BookPreviewBlocError.newCurrentPageNumberIsTooHigh,
      );
    } else if (bookError.code ==
        BookErrorCode.newCurrentPageIsLowerThanReadPagesAmount) {
      emitError<BookPreviewBlocError>(
        emit,
        BookPreviewBlocError.newCurrentPageIsLowerThanReadPagesAmount,
      );
    }
  }
}
