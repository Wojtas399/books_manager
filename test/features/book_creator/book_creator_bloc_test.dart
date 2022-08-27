import 'package:app/domain/use_cases/book/add_book_use_case.dart';
import 'package:app/features/book_creator/bloc/book_creator_bloc.dart';
import 'package:app/models/bloc_status.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAddBookUseCase extends Mock implements AddBookUseCase {}

void main() {
  final addBookUseCase = MockAddBookUseCase();

  BookCreatorBloc createBloc({
    String? imagePath,
    String title = '',
    String author = '',
    int readPagesAmount = 0,
    int allPagesAmount = 0,
  }) {
    return BookCreatorBloc(
      addBookUseCase: addBookUseCase,
      imagePath: imagePath,
      title: title,
      author: author,
      readPagesAmount: readPagesAmount,
      allPagesAmount: allPagesAmount,
    );
  }

  BookCreatorState createState({
    BlocStatus status = const BlocStatusInProgress(),
    String? imagePath,
    String title = '',
    String author = '',
    int allPagesAmount = 0,
    int readPagesAmount = 0,
  }) {
    return BookCreatorState(
      status: status,
      imagePath: imagePath,
      title: title,
      author: author,
      allPagesAmount: allPagesAmount,
      readPagesAmount: readPagesAmount,
    );
  }

  tearDown(() {
    reset(addBookUseCase);
  });

  blocTest(
    'change image path, should update image path',
    build: () => createBloc(),
    act: (BookCreatorBloc bloc) {
      bloc.add(
        const BookCreatorEventChangeImagePath(imagePath: 'imagePath'),
      );
    },
    expect: () => [
      createState(imagePath: 'imagePath'),
    ],
  );

  blocTest(
    'remove image, should set image path as null',
    build: () => createBloc(imagePath: 'imagePath'),
    act: (BookCreatorBloc bloc) {
      bloc.add(
        const BookCreatorEventRemoveImage(),
      );
    },
    expect: () => [
      createState(imagePath: null),
    ],
  );

  blocTest(
    'title changed, should update title',
    build: () => createBloc(),
    act: (BookCreatorBloc bloc) {
      bloc.add(
        const BookCreatorEventTitleChanged(title: 'title'),
      );
    },
    expect: () => [
      createState(title: 'title'),
    ],
  );

  blocTest(
    'author changed, should update author',
    build: () => createBloc(),
    act: (BookCreatorBloc bloc) {
      bloc.add(
        const BookCreatorEventAuthorChanged(author: 'author'),
      );
    },
    expect: () => [
      createState(author: 'author'),
    ],
  );

  blocTest(
    'read pages amount changed, should update read pages',
    build: () => createBloc(),
    act: (BookCreatorBloc bloc) {
      bloc.add(
        const BookCreatorEventReadPagesAmountChanged(readPagesAmount: 10),
      );
    },
    expect: () => [
      createState(readPagesAmount: 10),
    ],
  );

  blocTest(
    'all pages amount changed, should update all pages amount',
    build: () => createBloc(),
    act: (BookCreatorBloc bloc) {
      bloc.add(
        const BookCreatorEventAllPagesAmountChanged(allPagesAmount: 20),
      );
    },
    expect: () => [
      createState(allPagesAmount: 20),
    ],
  );

  group(
    'submit',
    () {
      const String title = 'title';
      const String author = 'author';
      const int readPagesAmount = 30;
      const int allPagesAmount = 300;

      blocTest(
        'should call use case responsible for adding new book',
        build: () => createBloc(
          title: title,
          author: author,
          readPagesAmount: readPagesAmount,
          allPagesAmount: allPagesAmount,
        ),
        setUp: () {
          when(
            () => addBookUseCase.execute(
              title: title,
              author: author,
              allPagesAmount: allPagesAmount,
              readPagesAmount: readPagesAmount,
            ),
          ).thenAnswer((_) async => '');
        },
        act: (BookCreatorBloc bloc) {
          bloc.add(
            const BookCreatorEventSubmit(),
          );
        },
        expect: () => [
          createState(
            status: const BlocStatusLoading(),
            title: title,
            author: author,
            readPagesAmount: readPagesAmount,
            allPagesAmount: allPagesAmount,
          ),
          createState(
            status: const BlocStatusComplete<BookCreatorBlocInfo>(
              info: BookCreatorBlocInfo.bookHasBeenAdded,
            ),
            title: title,
            author: author,
            readPagesAmount: readPagesAmount,
            allPagesAmount: allPagesAmount,
          ),
        ],
        verify: (_) {
          verify(
            () => addBookUseCase.execute(
              title: title,
              author: author,
              allPagesAmount: allPagesAmount,
              readPagesAmount: readPagesAmount,
            ),
          ).called(1);
        },
      );
    },
  );
}
