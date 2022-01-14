import 'package:app/core/book/book_bloc.dart';
import 'package:app/core/book/book_model.dart';
import 'package:app/core/book/book_query.dart';
import 'package:app/core/services/book_category_service.dart';
import 'package:app/modules/book_details/bloc/book_details_actions.dart';
import 'package:app/modules/book_details/bloc/book_details_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import '../global_mocks.dart';

void main() {
  final String bookId = 'b1';
  final BookQuery bookQuery = MockBookQuery();
  final BookBloc bookBloc = MockBookBloc();
  final BookCategoryService bookCategoryService = MockBookCategoryService();
  late BookDetailsBloc bloc;

  setUp(() {
    bloc = BookDetailsBloc(
      bookId: bookId,
      bookQuery: bookQuery,
      bookBloc: bookBloc,
      bookCategoryService: bookCategoryService,
    );
  });

  tearDown(() {
    reset(bookQuery);
    reset(bookBloc);
    reset(bookCategoryService);
  });

  blocTest(
    'pause reading',
    build: () => bloc,
    act: (BookDetailsBloc bookDetailsBloc) {
      bookDetailsBloc.add(BookDetailsActionsPauseReading());
    },
    verify: (_) {
      verify(
        () => bookBloc.updateBook(bookId: bookId, status: BookStatus.paused),
      ).called(1);
    },
  );

  blocTest(
    'start reading',
    build: () => bloc,
    act: (BookDetailsBloc bookDetailsBloc) {
      bookDetailsBloc.add(BookDetailsActionsStartReading());
    },
    verify: (_) {
      verify(
        () => bookBloc.updateBook(bookId: bookId, status: BookStatus.read),
      ).called(1);
    },
  );

  blocTest(
    'delete book',
    build: () => bloc,
    act: (BookDetailsBloc bookDetailsBloc) {
      bookDetailsBloc.add(BookDetailsActionsDeletedBook());
    },
    verify: (_) {
      verify(() => bookBloc.deleteBook(bookId: bookId)).called(1);
    },
  );

  blocTest(
    'update img',
    build: () => bloc,
    act: (BookDetailsBloc bookDetailsBloc) {
      bookDetailsBloc.add(BookDetailsActionsUpdateImg(
        newImgPath: 'new/img/path',
      ));
    },
    verify: (_) {
      verify(
        () => bookBloc.updateBookImg(
          bookId: bookId,
          newImgPath: 'new/img/path',
        ),
      ).called(1);
    },
  );

  blocTest(
    'update book',
    build: () => bloc,
    act: (BookDetailsBloc bookDetailsBloc) {
      bookDetailsBloc.add(BookDetailsActionsUpdateBook(
        author: 'new author',
        title: 'new title',
        category: BookCategory.art,
        readPages: 400,
        pages: 800,
      ));
    },
    verify: (_) {
      verify(
        () => bookBloc.updateBook(
          bookId: bookId,
          author: 'new author',
          title: 'new title',
          category: BookCategory.art,
          readPages: 400,
          pages: 800,
        ),
      ).called(1);
    },
  );
}
