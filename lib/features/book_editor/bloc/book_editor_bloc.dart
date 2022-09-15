import 'dart:typed_data';

import 'package:app/domain/entities/book.dart';
import 'package:app/domain/use_cases/book/get_book_by_id_use_case.dart';
import 'package:app/domain/use_cases/book/update_book_use_case.dart';
import 'package:app/models/bloc_state.dart';
import 'package:app/models/bloc_status.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'book_editor_event.dart';
part 'book_editor_state.dart';

class BookEditorBloc extends Bloc<BookEditorEvent, BookEditorState> {
  late final GetBookByIdUseCase _getBookByIdUseCase;
  late final UpdateBookUseCase _updateBookUseCase;

  BookEditorBloc({
    required GetBookByIdUseCase getBookByIdUseCase,
    required UpdateBookUseCase updateBookUseCase,
    BlocStatus status = const BlocStatusInitial(),
    Book? originalBook,
    Uint8List? imageData,
    String title = '',
    String author = '',
    int readPagesAmount = 0,
    int allPagesAmount = 0,
  }) : super(
          BookEditorState(
            status: status,
            originalBook: originalBook,
            imageData: imageData,
            title: title,
            author: author,
            readPagesAmount: readPagesAmount,
            allPagesAmount: allPagesAmount,
          ),
        ) {
    _getBookByIdUseCase = getBookByIdUseCase;
    _updateBookUseCase = updateBookUseCase;
    on<BookEditorEventInitialize>(_initialize);
    on<BookEditorEventImageChanged>(_imageChanged);
    on<BookEditorEventRestoreOriginalImage>(_restoreOriginalImage);
    on<BookEditorEventTitleChanged>(_titleChanged);
    on<BookEditorEventAuthorChanged>(_authorChanged);
    on<BookEditorEventReadPagesAmountChanged>(_readPagesAmountChanged);
    on<BookEditorEventAllPagesAmountChanged>(_allPagesAmountChanged);
    on<BookEditorEventSubmit>(_submit);
  }

  Future<void> _initialize(
    BookEditorEventInitialize event,
    Emitter<BookEditorState> emit,
  ) async {
    emit(state.copyWith(
      status: const BlocStatusLoading(),
    ));
    final Book book =
        await _getBookByIdUseCase.execute(bookId: event.bookId).first;
    emit(state.copyWith(
      status: const BlocStatusComplete(),
      originalBook: book,
      imageData: book.imageData,
      title: book.title,
      author: book.author,
      readPagesAmount: book.readPagesAmount,
      allPagesAmount: book.allPagesAmount,
    ));
  }

  void _imageChanged(
    BookEditorEventImageChanged event,
    Emitter<BookEditorState> emit,
  ) {
    emit(state.copyWith(
      imageData: event.imageData,
      deletedImage: event.imageData == null,
    ));
  }

  void _restoreOriginalImage(
    BookEditorEventRestoreOriginalImage event,
    Emitter<BookEditorState> emit,
  ) {
    emit(state.copyWith(
      imageData: state.originalBook?.imageData,
    ));
  }

  void _titleChanged(
    BookEditorEventTitleChanged event,
    Emitter<BookEditorState> emit,
  ) {
    emit(state.copyWith(
      title: event.title,
    ));
  }

  void _authorChanged(
    BookEditorEventAuthorChanged event,
    Emitter<BookEditorState> emit,
  ) {
    emit(state.copyWith(
      author: event.author,
    ));
  }

  void _readPagesAmountChanged(
    BookEditorEventReadPagesAmountChanged event,
    Emitter<BookEditorState> emit,
  ) {
    emit(state.copyWith(
      readPagesAmount: event.readPagesAmount,
    ));
  }

  void _allPagesAmountChanged(
    BookEditorEventAllPagesAmountChanged event,
    Emitter<BookEditorState> emit,
  ) {
    emit(state.copyWith(
      allPagesAmount: event.allPagesAmount,
    ));
  }

  Future<void> _submit(
    BookEditorEventSubmit event,
    Emitter<BookEditorState> emit,
  ) async {
    final Book? originalBook = state.originalBook;
    if (originalBook != null) {
      emit(state.copyWith(
        status: const BlocStatusLoading(),
      ));
      await _updateBookUseCase.execute(
        bookId: originalBook.id,
        userId: originalBook.userId,
        imageData: state.imageData,
        deleteImage: state.imageData == null,
        title: state.title,
        author: state.author,
        readPagesAmount: state.readPagesAmount,
        allPagesAmount: state.allPagesAmount,
      );
      emit(state.copyWithInfo(
        BookEditorBlocInfo.bookHasBeenUpdated,
      ));
    }
  }
}
