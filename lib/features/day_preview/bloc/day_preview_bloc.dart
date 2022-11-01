import 'dart:typed_data';

import 'package:app/domain/entities/book.dart';
import 'package:app/domain/entities/read_book.dart';
import 'package:app/domain/use_cases/auth/get_logged_user_id_use_case.dart';
import 'package:app/domain/use_cases/book/get_book_use_case.dart';
import 'package:app/models/bloc_state.dart';
import 'package:app/models/bloc_status.dart';
import 'package:app/models/custom_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'day_preview_event.dart';
part 'day_preview_state.dart';

class DayPreviewBloc extends CustomBloc<DayPreviewEvent, DayPreviewState> {
  late final GetLoggedUserIdUseCase _getLoggedUserIdUseCase;
  late final GetBookUseCase _getBookUseCase;

  DayPreviewBloc({
    required GetLoggedUserIdUseCase getLoggedUserIdUseCase,
    required GetBookUseCase getBookUseCase,
    BlocStatus status = const BlocStatusInitial(),
    DateTime? date,
    List<DayPreviewBook> dayPreviewBooks = const [],
  }) : super(
          DayPreviewState(
            status: status,
            date: date,
            dayPreviewBooks: dayPreviewBooks,
          ),
        ) {
    _getLoggedUserIdUseCase = getLoggedUserIdUseCase;
    _getBookUseCase = getBookUseCase;
    on<DayPreviewEventInitialize>(_initialize);
  }

  Future<void> _initialize(
    DayPreviewEventInitialize event,
    Emitter<DayPreviewState> emit,
  ) async {
    emitLoadingStatus(emit);
    final String? loggedUserId = await _getLoggedUserIdUseCase.execute().first;
    if (loggedUserId == null) {
      emitLoggedUserNotFoundStatus(emit);
      return;
    }
    final List<DayPreviewBook> dayPreviewBooks = await _createDayPreviewBooks(
      event.readBooks,
      loggedUserId,
    );
    emit(state.copyWith(
      date: event.date,
      dayPreviewBooks: dayPreviewBooks,
    ));
  }

  Future<List<DayPreviewBook>> _createDayPreviewBooks(
    List<ReadBook> readBooks,
    String userId,
  ) async {
    final List<DayPreviewBook> dayPreviewBooks = [];
    for (final ReadBook readBook in readBooks) {
      final DayPreviewBook? dayPreviewBook = await _createDayPreviewBook(
        readBook,
        userId,
      );
      if (dayPreviewBook != null) {
        dayPreviewBooks.add(dayPreviewBook);
      }
    }
    return dayPreviewBooks;
  }

  Future<DayPreviewBook?> _createDayPreviewBook(
    ReadBook readBook,
    String userId,
  ) async {
    final Book? book = await _getBook(readBook.bookId, userId);
    if (book == null) {
      return null;
    }
    return DayPreviewBook(
      id: readBook.bookId,
      imageData: book.imageFile?.data,
      title: book.title,
      author: book.author,
      amountOfPagesReadInThisDay: readBook.readPagesAmount,
    );
  }

  Future<Book?> _getBook(String bookId, String userId) async {
    return await _getBookUseCase.execute(bookId: bookId, userId: userId).first;
  }
}
