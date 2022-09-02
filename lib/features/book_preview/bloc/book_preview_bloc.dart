import 'package:app/domain/entities/book.dart';
import 'package:app/models/bloc_state.dart';
import 'package:app/models/bloc_status.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'book_preview_event.dart';
part 'book_preview_state.dart';

class BookPreviewBloc extends Bloc<BookPreviewEvent, BookPreviewState> {
  BookPreviewBloc({
    BlocStatus status = const BlocStatusInitial(),
    Book? book,
  }) : super(
          BookPreviewState(
            status: status,
            book: book,
          ),
        ) {
    on<BookPreviewEventInitialize>(_initialize);
  }

  void _initialize(
    BookPreviewEventInitialize event,
    Emitter<BookPreviewState> emit,
  ) {
    //TODO
  }
}
