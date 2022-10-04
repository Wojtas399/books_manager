import 'dart:typed_data';

import 'package:app/domain/entities/book.dart';
import 'package:app/domain/entities/read_book.dart';
import 'package:app/domain/use_cases/auth/get_logged_user_id_use_case.dart';
import 'package:app/domain/use_cases/book/get_book_by_id_use_case.dart';
import 'package:app/models/bloc_state.dart';
import 'package:app/models/bloc_status.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'day_preview_event.dart';
part 'day_preview_state.dart';

class DayPreviewBloc extends Bloc<DayPreviewEvent, DayPreviewState> {
  late final GetLoggedUserIdUseCase _getLoggedUserIdUseCase;
  late final GetBookByIdUseCase _getBookByIdUseCase;

  DayPreviewBloc({
    required GetLoggedUserIdUseCase getLoggedUserIdUseCase,
    required GetBookByIdUseCase getBookByIdUseCase,
    BlocStatus status = const BlocStatusInitial(),
    DateTime? date,
    List<DayPreviewReadBook> dayPreviewReadBooks = const [],
  }) : super(
          DayPreviewState(
            status: status,
            date: date,
            dayPreviewReadBooks: dayPreviewReadBooks,
          ),
        ) {
    _getLoggedUserIdUseCase = getLoggedUserIdUseCase;
    _getBookByIdUseCase = getBookByIdUseCase;
    on<DayPreviewEventInitialize>(_initialize);
  }

  Future<void> _initialize(
    DayPreviewEventInitialize event,
    Emitter<DayPreviewState> emit,
  ) async {
    emit(state.copyWith(
      status: const BlocStatusLoading(),
    ));
    final String? loggedUserId = await _getLoggedUserIdUseCase.execute().first;
    if (loggedUserId == null) {
      emit(state.copyWith(
        status: const BlocStatusLoggedUserNotFound(),
      ));
      return;
    }
    final List<DayPreviewReadBook> dayPreviewReadBooks =
        await _convertReadBooksToDayPreviewModels(event.readBooks);
    emit(state.copyWith(
      date: event.date,
      dayPreviewReadBooks: dayPreviewReadBooks,
    ));
  }

  Future<List<DayPreviewReadBook>> _convertReadBooksToDayPreviewModels(
    List<ReadBook> readBooks,
  ) async {
    final List<DayPreviewReadBook> dayPreviewModels = [];
    for (final ReadBook readBook in readBooks) {
      final DayPreviewReadBook newDayPreviewModel =
          await _createDayPreviewModelFromReadBook(readBook);
      dayPreviewModels.add(newDayPreviewModel);
    }
    return dayPreviewModels;
  }

  Future<DayPreviewReadBook> _createDayPreviewModelFromReadBook(
    ReadBook readBook,
  ) async {
    final Book book =
        await _getBookByIdUseCase.execute(bookId: readBook.bookId).first;
    return DayPreviewReadBook(
      bookId: readBook.bookId,
      imageData: book.imageData,
      title: book.title,
      author: book.author,
      amountOfPagesReadInThisDay: readBook.readPagesAmount,
    );
  }
}
