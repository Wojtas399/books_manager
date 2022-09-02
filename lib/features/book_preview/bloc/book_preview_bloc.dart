import 'dart:async';
import 'dart:typed_data';

import 'package:app/domain/entities/book.dart';
import 'package:app/domain/use_cases/book/get_book_by_id_use_case.dart';
import 'package:app/models/bloc_state.dart';
import 'package:app/models/bloc_status.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'book_preview_event.dart';
part 'book_preview_state.dart';

class BookPreviewBloc extends Bloc<BookPreviewEvent, BookPreviewState> {
  late final GetBookByIdUseCase _getBookByIdUseCase;
  StreamSubscription<Book>? _bookListener;

  BookPreviewBloc({
    required GetBookByIdUseCase getBookByIdUseCase,
    BlocStatus status = const BlocStatusInitial(),
    Book? book,
  }) : super(
          BookPreviewState(
            status: status,
            book: book,
          ),
        ) {
    _getBookByIdUseCase = getBookByIdUseCase;
    on<BookPreviewEventInitialize>(_initialize);
    on<BookPreviewEventBookUpdated>(_bookUpdated);
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

  void _setBookListener(String bookId) {
    _bookListener ??= _getBookByIdUseCase
        .execute(bookId: bookId)
        .listen((Book book) => add(BookPreviewEventBookUpdated(book: book)));
  }
}
