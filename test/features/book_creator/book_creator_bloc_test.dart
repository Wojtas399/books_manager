import 'package:app/domain/entities/book.dart';
import 'package:app/domain/use_cases/auth/get_logged_user_id_use_case.dart';
import 'package:app/domain/use_cases/book/add_book_use_case.dart';
import 'package:app/features/book_creator/bloc/book_creator_bloc.dart';
import 'package:app/models/bloc_status.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetLoggedUserIdUseCase extends Mock
    implements GetLoggedUserIdUseCase {}

class MockAddBookUseCase extends Mock implements AddBookUseCase {}

void main() {
  final getLoggedUserIdUseCase = MockGetLoggedUserIdUseCase();
  final addBookUseCase = MockAddBookUseCase();

  BookCreatorBloc createBloc({
    String? imagePath,
    String title = '',
    String author = '',
    int readPagesAmount = 0,
    int allPagesAmount = 0,
  }) {
    return BookCreatorBloc(
      getLoggedUserIdUseCase: getLoggedUserIdUseCase,
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
    reset(getLoggedUserIdUseCase);
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
      const String loggedUserId = 'loggedUserId';
      const String title = 'title';
      const String author = 'author';
      const int readPagesAmount = 20;
      const int allPagesAmount = 200;

      setUp(() {
        when(
          () => addBookUseCase.execute(
            userId: any(named: 'userId'),
            status: BookStatus.unread,
            imageData: any(named: 'imageData'),
            title: any(named: 'title'),
            author: any(named: 'author'),
            readPagesAmount: any(named: 'readPagesAmount'),
            allPagesAmount: any(named: 'allPagesAmount'),
          ),
        ).thenAnswer((_) async => '');
      });

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
            () => getLoggedUserIdUseCase.execute(),
          ).thenAnswer((_) => Stream.value(loggedUserId));
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
              userId: loggedUserId,
              status: BookStatus.unread,
              imageData: null,
              title: title,
              author: author,
              readPagesAmount: readPagesAmount,
              allPagesAmount: allPagesAmount,
            ),
          ).called(1);
        },
      );

      blocTest(
        'should not call use case responsible for adding new book if logged user id is null',
        build: () => createBloc(),
        setUp: () {
          when(
            () => getLoggedUserIdUseCase.execute(),
          ).thenAnswer((_) => Stream.value(null));
        },
        act: (BookCreatorBloc bloc) {
          bloc.add(
            const BookCreatorEventSubmit(),
          );
        },
        expect: () => [
          createState(
            status: const BlocStatusLoading(),
          ),
          createState(
            status: const BlocStatusLoggedUserNotFound(),
          ),
        ],
        verify: (_) {
          verifyNever(
            () => addBookUseCase.execute(
              userId: any(named: 'userId'),
              status: BookStatus.unread,
              imageData: any(named: 'imageData'),
              title: any(named: 'title'),
              author: any(named: 'author'),
              readPagesAmount: any(named: 'readPagesAmount'),
              allPagesAmount: any(named: 'allPagesAmount'),
            ),
          );
        },
      );
    },
  );
}
