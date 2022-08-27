import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'book_creator_event.dart';
part 'book_creator_state.dart';

class BookCreatorBloc extends Bloc<BookCreatorEvent, BookCreatorState> {
  BookCreatorBloc({
    String? imagePath,
    String title = '',
    String author = '',
    int allPagesAmount = 0,
    int readPagesAmount = 0,
  }) : super(
          BookCreatorState(
            imagePath: imagePath,
            title: title,
            author: author,
            allPagesAmount: allPagesAmount,
            readPagesAmount: readPagesAmount,
          ),
        ) {
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

  void _submit(
    BookCreatorEventSubmit event,
    Emitter<BookCreatorState> emit,
  ) {
    //TODO
  }
}
