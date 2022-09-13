import 'dart:typed_data';

import 'package:app/domain/entities/book.dart';
import 'package:app/domain/use_cases/book/get_book_by_id_use_case.dart';
import 'package:app/domain/use_cases/book/update_book_use_case.dart';
import 'package:app/features/book_editor/bloc/book_editor_bloc.dart';
import 'package:app/models/bloc_status.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetBookByIdUseCase extends Mock implements GetBookByIdUseCase {}

class MockUpdateBookUseCase extends Mock implements UpdateBookUseCase {}

void main() {
  final getBookByIdUseCase = MockGetBookByIdUseCase();
  final updateBookUseCase = MockUpdateBookUseCase();

  BookEditorBloc createBloc({
    Book? originalBook,
    Uint8List? imageData,
    String title = '',
    String author = '',
    int readPagesAmount = 0,
    int allPagesAmount = 0,
  }) {
    return BookEditorBloc(
      getBookByIdUseCase: getBookByIdUseCase,
      updateBookUseCase: updateBookUseCase,
      originalBook: originalBook,
      imageData: imageData,
      title: title,
      author: author,
      readPagesAmount: readPagesAmount,
      allPagesAmount: allPagesAmount,
    );
  }

  BookEditorState createState({
    BlocStatus status = const BlocStatusInitial(),
    Book? originalBook,
    Uint8List? imageData,
    String title = '',
    String author = '',
    int readPagesAmount = 0,
    int allPagesAmount = 0,
  }) {
    return BookEditorState(
      status: status,
      originalBook: originalBook,
      imageData: imageData,
      title: title,
      author: author,
      readPagesAmount: readPagesAmount,
      allPagesAmount: allPagesAmount,
    );
  }

  group(
    'initialize',
    () {
      const String bookId = 'b1';
      final Book book = createBook(
        id: bookId,
        imageData: Uint8List(10),
        title: 'title',
        author: 'author',
        readPagesAmount: 0,
        allPagesAmount: 100,
      );

      blocTest(
        'should load book and assign its params to state',
        build: () => createBloc(),
        setUp: () {
          when(
            () => getBookByIdUseCase.execute(bookId: bookId),
          ).thenAnswer((_) => Stream.value(book));
        },
        act: (BookEditorBloc bloc) {
          bloc.add(
            const BookEditorEventInitialize(bookId: bookId),
          );
        },
        expect: () => [
          createState(
            status: const BlocStatusLoading(),
          ),
          createState(
            status: const BlocStatusComplete(),
            originalBook: book,
            imageData: book.imageData,
            title: book.title,
            author: book.author,
            readPagesAmount: book.readPagesAmount,
            allPagesAmount: book.allPagesAmount,
          ),
        ],
      );
    },
  );

  blocTest(
    'image changed, should update image data in state',
    build: () => createBloc(),
    act: (BookEditorBloc bloc) {
      bloc.add(
        BookEditorEventImageChanged(imageData: Uint8List(1)),
      );
    },
    expect: () => [
      createState(
        status: const BlocStatusInProgress(),
        imageData: Uint8List(1),
      ),
    ],
  );

  group(
    'restore original image',
    () {
      final Uint8List imageData = Uint8List(1);
      final Book book = createBook(imageData: imageData);

      blocTest(
        'should assign image from original book to image',
        build: () => createBloc(originalBook: book),
        act: (BookEditorBloc bloc) {
          bloc.add(
            const BookEditorEventRestoreOriginalImage(),
          );
        },
        expect: () => [
          createState(
            status: const BlocStatusInProgress(),
            originalBook: book,
            imageData: imageData,
          ),
        ],
      );
    },
  );

  blocTest(
    'delete image, should set image data as null',
    build: () => createBloc(
      imageData: Uint8List(1),
    ),
    act: (BookEditorBloc bloc) {
      bloc.add(
        const BookEditorEventDeleteImage(),
      );
    },
    expect: () => [
      createState(
        status: const BlocStatusInProgress(),
        imageData: null,
      ),
    ],
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
        status: const BlocStatusInProgress(),
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
        status: const BlocStatusInProgress(),
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
        status: const BlocStatusInProgress(),
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
        status: const BlocStatusInProgress(),
        allPagesAmount: 100,
      ),
    ],
  );

  group(
    'submit',
    () {
      final Book originalBook = createBook(id: 'b1', userId: 'u1');
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

      setUp(() {
        when(
          () => updateBookUseCase.execute(
            bookId: originalBook.id,
            userId: originalBook.userId,
            imageData: any(named: 'imageData'),
            deleteImage: any(named: 'deleteImage'),
            title: newTitle,
            author: newAuthor,
            readPagesAmount: newReadPagesAmount,
            allPagesAmount: newAllPagesAmount,
          ),
        ).thenAnswer((_) async => '');
      });

      blocTest(
        'should call use case responsible for updating book',
        build: () => createBloc(
          originalBook: originalBook,
          imageData: Uint8List(1),
          title: newTitle,
          author: newAuthor,
          readPagesAmount: newReadPagesAmount,
          allPagesAmount: newAllPagesAmount,
        ),
        act: (BookEditorBloc bloc) {
          bloc.add(
            const BookEditorEventSubmit(),
          );
        },
        expect: () => [
          state.copyWith(
            status: const BlocStatusLoading(),
            imageData: Uint8List(1),
          ),
          state.copyWith(
            status: const BlocStatusComplete<BookEditorBlocInfo>(
              info: BookEditorBlocInfo.bookHasBeenUpdated,
            ),
            imageData: Uint8List(1),
          ),
        ],
        verify: (_) {
          verify(
            () => updateBookUseCase.execute(
              bookId: originalBook.id,
              userId: originalBook.userId,
              imageData: Uint8List(1),
              title: newTitle,
              author: newAuthor,
              readPagesAmount: newReadPagesAmount,
              allPagesAmount: newAllPagesAmount,
            ),
          ).called(1);
        },
      );

      blocTest(
        'should call use case responsible for updating book with delete image param set as true if image data is null',
        build: () => createBloc(
          originalBook: originalBook,
          imageData: null,
          title: newTitle,
          author: newAuthor,
          readPagesAmount: newReadPagesAmount,
          allPagesAmount: newAllPagesAmount,
        ),
        act: (BookEditorBloc bloc) {
          bloc.add(
            const BookEditorEventSubmit(),
          );
        },
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
              userId: originalBook.userId,
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