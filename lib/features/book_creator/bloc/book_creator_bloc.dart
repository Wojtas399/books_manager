import 'package:app/domain/entities/book.dart';
import 'package:app/domain/use_cases/auth/get_logged_user_id_use_case.dart';
import 'package:app/domain/use_cases/book/add_book_use_case.dart';
import 'package:app/models/bloc_state.dart';
import 'package:app/models/bloc_status.dart';
import 'package:app/models/custom_bloc.dart';
import 'package:app/models/image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'book_creator_event.dart';
part 'book_creator_state.dart';

class BookCreatorBloc extends CustomBloc<BookCreatorEvent, BookCreatorState> {
  late final GetLoggedUserIdUseCase _getLoggedUserIdUseCase;
  late final AddBookUseCase _addBookUseCase;

  BookCreatorBloc({
    required GetLoggedUserIdUseCase getLoggedUserIdUseCase,
    required AddBookUseCase addBookUseCase,
    BlocStatus status = const BlocStatusInitial(),
    Image? image,
    String title = '',
    String author = '',
    int allPagesAmount = 0,
    int readPagesAmount = 0,
  }) : super(
          BookCreatorState(
            status: status,
            image: image,
            title: title,
            author: author,
            allPagesAmount: allPagesAmount,
            readPagesAmount: readPagesAmount,
          ),
        ) {
    _getLoggedUserIdUseCase = getLoggedUserIdUseCase;
    _addBookUseCase = addBookUseCase;
    on<BookCreatorEventChangeImage>(_changeImage);
    on<BookCreatorEventTitleChanged>(_titleChanged);
    on<BookCreatorEventAuthorChanged>(_authorChanged);
    on<BookCreatorEventReadPagesAmountChanged>(_readPagesAmountChanged);
    on<BookCreatorEventAllPagesAmountChanged>(_allPagesAmountChanged);
    on<BookCreatorEventSubmit>(_submit);
  }

  void _changeImage(
    BookCreatorEventChangeImage event,
    Emitter<BookCreatorState> emit,
  ) {
    emit(state.copyWith(
      image: event.image,
      deletedImage: event.image == null,
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
    emitLoadingStatus(emit);
    final String? loggedUserId = await _getLoggedUserIdUseCase.execute().first;
    if (loggedUserId != null) {
      await _addBook(loggedUserId);
      emitInfo<BookCreatorBlocInfo>(emit, BookCreatorBlocInfo.bookHasBeenAdded);
    } else {
      emitLoggedUserNotFoundStatus(emit);
    }
  }

  Future<void> _addBook(String loggedUserId) async {
    await _addBookUseCase.execute(
      userId: loggedUserId,
      status: BookStatus.unread,
      image: state.image,
      title: state.title,
      author: state.author,
      readPagesAmount: state.readPagesAmount,
      allPagesAmount: state.allPagesAmount,
    );
  }
}
