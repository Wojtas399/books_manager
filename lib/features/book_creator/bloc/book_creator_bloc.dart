import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/book.dart';
import '../../../domain/use_cases/auth/get_logged_user_id_use_case.dart';
import '../../../domain/use_cases/book/add_book_use_case.dart';
import '../../../models/bloc_state.dart';
import '../../../models/bloc_status.dart';

part 'book_creator_event.dart';
part 'book_creator_state.dart';

class BookCreatorBloc extends Bloc<BookCreatorEvent, BookCreatorState> {
  late final GetLoggedUserIdUseCase _getLoggedUserIdUseCase;
  late final AddBookUseCase _addBookUseCase;

  BookCreatorBloc({
    required GetLoggedUserIdUseCase getLoggedUserIdUseCase,
    required AddBookUseCase addBookUseCase,
    BlocStatus status = const BlocStatusInitial(),
    String? imagePath,
    String title = '',
    String author = '',
    int allPagesAmount = 0,
    int readPagesAmount = 0,
  }) : super(
          BookCreatorState(
            status: status,
            imagePath: imagePath,
            title: title,
            author: author,
            allPagesAmount: allPagesAmount,
            readPagesAmount: readPagesAmount,
          ),
        ) {
    _getLoggedUserIdUseCase = getLoggedUserIdUseCase;
    _addBookUseCase = addBookUseCase;
    on<BookCreatorEventChangeImagePath>(_changeImagePath);
    on<BookCreatorEventRemoveImage>(_removeImage);
    on<BookCreatorEventTitleChanged>(_titleChanged);
    on<BookCreatorEventAuthorChanged>(_authorChanged);
    on<BookCreatorEventReadPagesAmountChanged>(_readPagesAmountChanged);
    on<BookCreatorEventAllPagesAmountChanged>(_allPagesAmountChanged);
    on<BookCreatorEventSubmit>(_submit);
  }

  void _changeImagePath(
    BookCreatorEventChangeImagePath event,
    Emitter<BookCreatorState> emit,
  ) {
    emit(state.copyWith(
      imagePath: event.imagePath,
    ));
  }

  void _removeImage(
    BookCreatorEventRemoveImage event,
    Emitter<BookCreatorState> emit,
  ) {
    emit(state.copyWith(
      removedImagePath: true,
    ));
  }

  void _titleChanged(
    BookCreatorEventTitleChanged event,
    Emitter<BookCreatorState> emit,
  ) {
    emit(state.copyWith(
      title: event.title,
    ));
  }

  void _authorChanged(
    BookCreatorEventAuthorChanged event,
    Emitter<BookCreatorState> emit,
  ) {
    emit(state.copyWith(
      author: event.author,
    ));
  }

  void _readPagesAmountChanged(
    BookCreatorEventReadPagesAmountChanged event,
    Emitter<BookCreatorState> emit,
  ) {
    emit(state.copyWith(
      readPagesAmount: event.readPagesAmount,
    ));
  }

  void _allPagesAmountChanged(
    BookCreatorEventAllPagesAmountChanged event,
    Emitter<BookCreatorState> emit,
  ) {
    emit(state.copyWith(
      allPagesAmount: event.allPagesAmount,
    ));
  }

  Future<void> _submit(
    BookCreatorEventSubmit event,
    Emitter<BookCreatorState> emit,
  ) async {
    emit(state.copyWith(
      status: const BlocStatusLoading(),
    ));
    final String? loggedUserId = await _getLoggedUserIdUseCase.execute().first;
    if (loggedUserId != null) {
      await _addBook(loggedUserId);
      emit(state.copyWithInfo(
        BookCreatorBlocInfo.bookHasBeenAdded,
      ));
    } else {
      emit(state.copyWith(
        status: const BlocStatusLoggedUserNotFound(),
      ));
    }
  }

  Future<void> _addBook(String loggedUserId) async {
    final String? imagePath = state.imagePath;
    await _addBookUseCase.execute(
      book: Book(
        userId: loggedUserId,
        status: BookStatus.unread,
        imageData: imagePath != null ? File(imagePath).readAsBytesSync() : null,
        title: state.title,
        author: state.author,
        readPagesAmount: state.readPagesAmount,
        allPagesAmount: state.allPagesAmount,
      ),
    );
  }
}
