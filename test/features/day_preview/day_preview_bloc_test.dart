import 'dart:typed_data';

import 'package:app/domain/entities/book.dart';
import 'package:app/domain/entities/read_book.dart';
import 'package:app/features/day_preview/bloc/day_preview_bloc.dart';
import 'package:app/models/bloc_status.dart';
import 'package:app/models/image.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../mocks/domain/use_cases/auth/mock_get_logged_user_id_use_case.dart';
import '../../mocks/domain/use_cases/book/mock_get_book_use_case.dart';

void main() {
  final getLoggedUserIdUseCase = MockGetLoggedUserIdUseCase();
  final getBookUseCase = MockGetBookUseCase();

  DayPreviewBloc createBloc() {
    return DayPreviewBloc(
      getLoggedUserIdUseCase: getLoggedUserIdUseCase,
      getBookUseCase: getBookUseCase,
    );
  }

  DayPreviewState createState({
    BlocStatus status = const BlocStatusInitial(),
    DateTime? date,
    List<DayPreviewBook> dayPreviewBooks = const [],
  }) {
    return DayPreviewState(
      status: status,
      date: date,
      dayPreviewBooks: dayPreviewBooks,
    );
  }

  tearDown(() {
    reset(getLoggedUserIdUseCase);
    reset(getBookUseCase);
  });

  group(
    'initialize',
    () {
      const String loggedUserId = 'u1';
      final DateTime date = DateTime(2022, 9, 20);
      final Book book1 = createBook(
        id: 'b1',
        image: createImage(fileName: 'i1.jpg', data: Uint8List(10)),
        title: 'title 1',
        author: 'author 1',
      );
      final Book book2 = createBook(
        id: 'b2',
        image: createImage(fileName: 'i2.jpg', data: Uint8List(20)),
        title: 'title 2',
        author: 'author 2',
      );
      final List<ReadBook> readBooks = [
        createReadBook(bookId: book1.id, readPagesAmount: 50),
        createReadBook(bookId: book2.id, readPagesAmount: 100),
      ];
      final List<DayPreviewBook> expectedDayPreviewBooks = [
        createDayPreviewBook(
          id: book1.id,
          imageData: book1.image?.data,
          title: book1.title,
          author: book1.author,
          amountOfPagesReadInThisDay: readBooks.first.readPagesAmount,
        ),
        createDayPreviewBook(
          id: book2.id,
          imageData: book2.image?.data,
          title: book2.title,
          author: book2.author,
          amountOfPagesReadInThisDay: readBooks.last.readPagesAmount,
        ),
      ];

      void eventCall(DayPreviewBloc bloc) => bloc.add(
            DayPreviewEventInitialize(date: date, readBooks: readBooks),
          );

      blocTest(
        'logged user does not exist, should emit appropriate status',
        build: () => createBloc(),
        setUp: () {
          getLoggedUserIdUseCase.mock();
        },
        act: (DayPreviewBloc bloc) => eventCall(bloc),
        expect: () => [
          createState(
            status: const BlocStatusLoading(),
          ),
          createState(
            status: const BlocStatusLoggedUserNotFound(),
          ),
        ],
      );

      blocTest(
        'logged user exist, should update date and should convert every given read book to day preview read book',
        build: () => createBloc(),
        setUp: () {
          getLoggedUserIdUseCase.mock(loggedUserId: loggedUserId);
          when(
            () => getBookUseCase.execute(
              bookId: book1.id,
              userId: loggedUserId,
            ),
          ).thenAnswer((_) => Stream.value(book1));
          when(
            () => getBookUseCase.execute(
              bookId: book2.id,
              userId: loggedUserId,
            ),
          ).thenAnswer((_) => Stream.value(book2));
        },
        act: (DayPreviewBloc bloc) => eventCall(bloc),
        expect: () => [
          createState(
            status: const BlocStatusLoading(),
          ),
          createState(
            status: const BlocStatusComplete(),
            date: date,
            dayPreviewBooks: expectedDayPreviewBooks,
          ),
        ],
        verify: (_) {
          verify(
            () => getBookUseCase.execute(
              bookId: book1.id,
              userId: loggedUserId,
            ),
          ).called(1);
          verify(
            () => getBookUseCase.execute(
              bookId: book2.id,
              userId: loggedUserId,
            ),
          ).called(1);
        },
      );
    },
  );
}
