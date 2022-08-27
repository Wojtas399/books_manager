import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/use_cases/book/add_book_use_case.dart';
import '../../../models/bloc_status.dart';

part 'book_creator_event.dart';
part 'book_creator_state.dart';

class BookCreatorBloc extends Bloc<BookCreatorEvent, BookCreatorState> {
  late final AddBookUseCase _addBookUseCase;

  BookCreatorBloc({
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
    await _addBookUseCase.execute(
      title: state.title,
      author: state.author,
      allPagesAmount: state.allPagesAmount,
      readPagesAmount: state.readPagesAmount,
    );
    emit(state.copyWithInfo(
      BookCreatorBlocInfo.bookHasBeenAdded,
    ));
  }
}
