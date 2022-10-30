import 'dart:typed_data';

import 'package:app/domain/entities/book.dart';
import 'package:app/features/book_editor/bloc/book_editor_bloc.dart';
import 'package:app/models/bloc_status.dart';
import 'package:app/models/image_file.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/domain/use_cases/auth/mock_get_logged_user_id_use_case.dart';
import '../../mocks/domain/use_cases/book/mock_get_book_use_case.dart';
import '../../mocks/domain/use_cases/book/mock_update_book_use_case.dart';

void main() {
  final getLoggedUserIdUseCase = MockGetLoggedUserIdUseCase();
  final getBookUseCase = MockGetBookUseCase();
  final updateBookUseCase = MockUpdateBookUseCase();
  const String bookId = 'b1';
  const String userId = 'u1';

  BookEditorBloc createBloc({
    Book? originalBook,
    ImageFile? imageFile,
    String title = '',
    String author = '',
    int readPagesAmount = 0,
    int allPagesAmount = 0,
  }) {
    return BookEditorBloc(
      getLoggedUserIdUseCase: getLoggedUserIdUseCase,
      getBookUseCase: getBookUseCase,
      updateBookUseCase: updateBookUseCase,
      originalBook: originalBook,
      imageFile: imageFile,
      title: title,
      author: author,
      readPagesAmount: readPagesAmount,
      allPagesAmount: allPagesAmount,
    );
  }

  BookEditorState createState({
    BlocStatus status = const BlocStatusInProgress(),
    Book? originalBook,
    ImageFile? imageFile,
    String title = '',
    String author = '',
    int readPagesAmount = 0,
    int allPagesAmount = 0,
  }) {
    return BookEditorState(
      status: status,
      originalBook: originalBook,
      imageFile: imageFile,
      title: title,
      author: author,
      readPagesAmount: readPagesAmount,
      allPagesAmount: allPagesAmount,
    );
  }

  tearDown(() {
    reset(getLoggedUserIdUseCase);
    reset(getBookUseCase);
    reset(updateBookUseCase);
  });

  group(
    'initialize',
    () {
      final Book book = createBook(
        id: bookId,
        userId: userId,
        imageFile: createImageFile(name: 'i1', data: Uint8List(10)),
        title: 'title',
        author: 'author',
        readPagesAmount: 0,
        allPagesAmount: 100,
      );

      void eventCall(BookEditorBloc bloc) => bloc.add(
            const BookEditorEventInitialize(bookId: bookId),
          );

      setUp(() {
        getBookUseCase.mock(book: book);
      });

      tearDown(() {
        verify(
          () => getLoggedUserIdUseCase.execute(),
        ).called(1);
      });

      blocTest(
        'logged user does not exist, should emit logged user not found status',
        build: () => createBloc(),
        setUp: () {
          getLoggedUserIdUseCase.mock();
        },
        act: (BookEditorBloc bloc) => eventCall(bloc),
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
        'logged user exists, should load book and assign its params to state',
        build: () => createBloc(),
        setUp: () {
          getLoggedUserIdUseCase.mock(loggedUserId: userId);
        },
        act: (BookEditorBloc bloc) => eventCall(bloc),
        expect: () => [
          createState(
            status: const BlocStatusLoading(),
          ),
          createState(
            status: const BlocStatusComplete(),
            originalBook: book,
            imageFile: book.imageFile,
            title: book.title,
            author: book.author,
            readPagesAmount: book.readPagesAmount,
            allPagesAmount: book.allPagesAmount,
          ),
        ],
        verify: (_) {
          verify(
            () => getBookUseCase.execute(
              bookId: bookId,
              userId: userId,
            ),
          ).called(1);
        },
      );
    },
  );

  group(
    'image changed',
    () {
      void eventCall(BookEditorBloc bloc, ImageFile? imageFile) {
        bloc.add(
          BookEditorEventImageChanged(imageFile: imageFile),
        );
      }

      blocTest(
        'should update image file in state',
        build: () => createBloc(),
        act: (BookEditorBloc bloc) => eventCall(bloc, createImageFile()),
        expect: () => [
          createState(
            imageFile: createImageFile(),
          ),
        ],
      );

      blocTest(
        'should set image file as null if given image file is null',
        build: () => createBloc(
          imageFile: createImageFile(),
        ),
        act: (BookEditorBloc bloc) => eventCall(bloc, null),
        expect: () => [
          createState(
            imageFile: null,
          ),
        ],
      );
    },
  );

  group(
    'restore original image',
    () {
      final ImageFile imageFile = createImageFile();
      final Book book = createBook(imageFile: imageFile);

      blocTest(
        'should assign image file from original book to image file in state',
        build: () => createBloc(originalBook: book),
        act: (BookEditorBloc bloc) {
          bloc.add(
            const BookEditorEventRestoreOriginalImage(),
          );
        },
        expect: () => [
          createState(
            originalBook: book,
            imageFile: imageFile,
          ),
        ],
      );
    },
  );

  blocTest(
    'title changed, should update title in state',
    build: () => createBloc(),
    act: (BookEditorBloc bloc) {
      bloc.add(
        const BookEditorEventTitleChanged(title: 'title'),
      );
    },
    expect: () => [
      createState(
        title: 'title',
      ),
    ],
  );

  blocTest(
    'author changed, should update author in state',
    build: () => createBloc(),
    act: (BookEditorBloc bloc) {
      bloc.add(
        const BookEditorEventAuthorChanged(author: 'author'),
      );
    },
    expect: () => [
      createState(
        author: 'author',
      ),
    ],
  );

  blocTest(
    'read pages amount changed, should update read pages amount in state',
    build: () => createBloc(),
    act: (BookEditorBloc bloc) {
      bloc.add(
        const BookEditorEventReadPagesAmountChanged(readPagesAmount: 20),
      );
    },
    expect: () => [
      createState(
        readPagesAmount: 20,
      ),
    ],
  );

  blocTest(
    'all pages amount changed, should update all pages amount in state',
    build: () => createBloc(),
    act: (BookEditorBloc bloc) {
      bloc.add(
        const BookEditorEventAllPagesAmountChanged(allPagesAmount: 100),
      );
    },
    expect: () => [
      createState(
        allPagesAmount: 100,
      ),
    ],
  );

  group(
    'submit',
    () {
      final Book originalBook = createBook(id: 'b1', userId: userId);
      final ImageFile newImageFile = createImageFile(name: 'i1');
      const String newTitle = 'new title';
      const String newAuthor = 'new author';
      const int newReadPagesAmount = 20;
      const int newAllPagesAmount = 100;
      final BookEditorState state = createState(
        originalBook: originalBook,
        title: newTitle,
        author: newAuthor,
        readPagesAmount: newReadPagesAmount,
        allPagesAmount: newAllPagesAmount,
      );

      BookEditorBloc createUpdatedBloc({
        Book? originalBook,
        ImageFile? imageFile,
      }) {
        return createBloc(
          originalBook: originalBook,
          imageFile: imageFile,
          title: newTitle,
          author: newAuthor,
          readPagesAmount: newReadPagesAmount,
          allPagesAmount: newAllPagesAmount,
        );
      }

      void eventCall(BookEditorBloc bloc) {
        bloc.add(
          const BookEditorEventSubmit(),
        );
      }

      setUp(() {
        updateBookUseCase.mock();
      });

      blocTest(
        'should do nothing if book is original book is not set',
        build: () => createUpdatedBloc(imageFile: newImageFile),
        act: (BookEditorBloc bloc) => eventCall(bloc),
        expect: () => [],
        verify: (_) {
          verifyNever(
            () => updateBookUseCase.execute(
              bookId: any(named: 'bookId'),
              userId: any(named: 'userId'),
              imageFile: newImageFile,
              title: newTitle,
              author: newAuthor,
              readPagesAmount: newReadPagesAmount,
              allPagesAmount: newAllPagesAmount,
            ),
          );
        },
      );

      blocTest(
        'should call use case responsible for updating book',
        build: () => createUpdatedBloc(
          originalBook: originalBook,
          imageFile: newImageFile,
        ),
        act: (BookEditorBloc bloc) => eventCall(bloc),
        expect: () => [
          state.copyWith(
            status: const BlocStatusLoading(),
            imageFile: newImageFile,
          ),
          state.copyWith(
            status: const BlocStatusComplete<BookEditorBlocInfo>(
              info: BookEditorBlocInfo.bookHasBeenUpdated,
            ),
            imageFile: newImageFile,
          ),
        ],
        verify: (_) {
          verify(
            () => updateBookUseCase.execute(
              bookId: originalBook.id,
              userId: userId,
              imageFile: newImageFile,
              title: newTitle,
              author: newAuthor,
              readPagesAmount: newReadPagesAmount,
              allPagesAmount: newAllPagesAmount,
            ),
          ).called(1);
        },
      );

      blocTest(
        'should call use case responsible for updating book with delete image param set as true if new image file is null',
        build: () => createUpdatedBloc(originalBook: originalBook),
        act: (BookEditorBloc bloc) => eventCall(bloc),
        expect: () => [
          state.copyWith(
            status: const BlocStatusLoading(),
          ),
          state.copyWith(
            status: const BlocStatusComplete<BookEditorBlocInfo>(
              info: BookEditorBlocInfo.bookHasBeenUpdated,
            ),
          ),
        ],
        verify: (_) {
          verify(
            () => updateBookUseCase.execute(
              bookId: originalBook.id,
              userId: userId,
              deleteImage: true,
              title: newTitle,
              author: newAuthor,
              readPagesAmount: newReadPagesAmount,
              allPagesAmount: newAllPagesAmount,
            ),
          ).called(1);
        },
      );
    },
  );
}
