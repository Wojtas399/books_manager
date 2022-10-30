import 'package:app/domain/entities/book.dart';
import 'package:app/domain/use_cases/auth/get_logged_user_id_use_case.dart';
import 'package:app/domain/use_cases/book/get_book_use_case.dart';
import 'package:app/domain/use_cases/book/update_book_use_case.dart';
import 'package:app/models/bloc_state.dart';
import 'package:app/models/bloc_status.dart';
import 'package:app/models/custom_bloc.dart';
import 'package:app/models/image_file.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'book_editor_event.dart';
part 'book_editor_state.dart';

class BookEditorBloc extends CustomBloc<BookEditorEvent, BookEditorState> {
  late final GetLoggedUserIdUseCase _getLoggedUserIdUseCase;
  late final GetBookUseCase _getBookUseCase;
  late final UpdateBookUseCase _updateBookUseCase;

  BookEditorBloc({
    required GetLoggedUserIdUseCase getLoggedUserIdUseCase,
    required GetBookUseCase getBookUseCase,
    required UpdateBookUseCase updateBookUseCase,
    BlocStatus status = const BlocStatusInitial(),
    Book? originalBook,
    ImageFile? imageFile,
    String title = '',
    String author = '',
    int readPagesAmount = 0,
    int allPagesAmount = 0,
  }) : super(
          BookEditorState(
            status: status,
            originalBook: originalBook,
            imageFile: imageFile,
            title: title,
            author: author,
            readPagesAmount: readPagesAmount,
            allPagesAmount: allPagesAmount,
          ),
        ) {
    _getLoggedUserIdUseCase = getLoggedUserIdUseCase;
    _getBookUseCase = getBookUseCase;
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
    emitLoadingStatus(emit);
    final String? loggedUserId = await _getLoggedUserIdUseCase.execute().first;
    if (loggedUserId == null) {
      emitLoggedUserNotFoundStatus(emit);
      return;
    }
    final Book? book = await _getBookUseCase
        .execute(bookId: event.bookId, userId: loggedUserId)
        .first;
    emit(state.copyWith(
      status: const BlocStatusComplete(),
      originalBook: book,
      imageFile: book?.imageFile,
      title: book?.title,
      author: book?.author,
      readPagesAmount: book?.readPagesAmount,
      allPagesAmount: book?.allPagesAmount,
    ));
  }

  void _imageChanged(
    BookEditorEventImageChanged event,
    Emitter<BookEditorState> emit,
  ) {
    emit(state.copyWith(
      imageFile: event.imageFile,
      deletedImage: event.imageFile == null,
    ));
  }

  void _restoreOriginalImage(
    BookEditorEventRestoreOriginalImage event,
    Emitter<BookEditorState> emit,
  ) {
    emit(state.copyWith(
      imageFile: state.originalBook?.imageFile,
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
    final String? bookId = state.originalBook?.id;
    final String? userId = state.originalBook?.userId;
    if (bookId != null && userId != null) {
      emitLoadingStatus(emit);
      await _updateBookUseCase.execute(
        bookId: bookId,
        userId: userId,
        imageFile: state.imageFile,
        deleteImage: state.imageFile == null,
        title: state.title,
        author: state.author,
        readPagesAmount: state.readPagesAmount,
        allPagesAmount: state.allPagesAmount,
      );
      emitInfo<BookEditorBlocInfo>(emit, BookEditorBlocInfo.bookHasBeenUpdated);
    }
  }
}
