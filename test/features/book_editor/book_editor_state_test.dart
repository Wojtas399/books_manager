import 'dart:typed_data';

import 'package:app/domain/entities/book.dart';
import 'package:app/features/book_editor/bloc/book_editor_bloc.dart';
import 'package:app/models/bloc_status.dart';
import 'package:app/models/image.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late BookEditorState state;

  setUp(() {
    state = const BookEditorState(
      status: BlocStatusInitial(),
      originalBook: null,
      image: null,
      title: '',
      author: '',
      readPagesAmount: 0,
      allPagesAmount: 0,
    );
  });

  group(
    'is button disabled',
    () {
      final Book book = createBook(
        image: createImage(fileName: 'i1.jpg', data: Uint8List(10)),
        title: 'title',
        author: 'author',
        readPagesAmount: 0,
        allPagesAmount: 100,
      );

      test(
        'should be true if all params are the same as original',
        () {
          state = state.copyWith(
            originalBook: book,
            image: book.image,
            title: book.title,
            author: book.author,
            readPagesAmount: book.readPagesAmount,
            allPagesAmount: book.allPagesAmount,
          );

          expect(state.isButtonDisabled, true);
        },
      );

      test(
        'should be false if image file is different than original',
        () {
          state = state.copyWith(
            originalBook: book,
            image: createImage(fileName: 'i2.jpg', data: Uint8List(10)),
            title: book.title,
            author: book.author,
            readPagesAmount: book.readPagesAmount,
            allPagesAmount: book.allPagesAmount,
          );

          expect(state.isButtonDisabled, false);
        },
      );

      test(
        'should be false if title is different than original',
        () {
          state = state.copyWith(
            originalBook: book,
            image: book.image,
            title: 'book title',
            author: book.author,
            readPagesAmount: book.readPagesAmount,
            allPagesAmount: book.allPagesAmount,
          );

          expect(state.isButtonDisabled, false);
        },
      );

      test(
        'should be false if author is different than original',
        () {
          state = state.copyWith(
            originalBook: book,
            image: book.image,
            title: book.title,
            author: 'book author',
            readPagesAmount: book.readPagesAmount,
            allPagesAmount: book.allPagesAmount,
          );

          expect(state.isButtonDisabled, false);
        },
      );

      test(
        'should be false if read pages amount is different than original',
        () {
          state = state.copyWith(
            originalBook: book,
            image: book.image,
            title: book.title,
            author: book.author,
            readPagesAmount: 100,
            allPagesAmount: book.allPagesAmount,
          );

          expect(state.isButtonDisabled, false);
        },
      );

      test(
        'should be false if all pages amount is different than original',
        () {
          state = state.copyWith(
            originalBook: book,
            image: book.image,
            title: book.title,
            author: book.author,
            readPagesAmount: book.readPagesAmount,
            allPagesAmount: 1,
          );

          expect(state.isButtonDisabled, false);
        },
      );
    },
  );

  test(
    'copy with status',
    () {
      const BlocStatus expectedStatus = BlocStatusLoading();

      state = state.copyWith(status: expectedStatus);
      final state2 = state.copyWith();

      expect(state.status, expectedStatus);
      expect(state2.status, const BlocStatusInProgress());
    },
  );

  test(
    'copy with original book',
    () {
      final Book expectedBook = createBook(id: 'b1');

      state = state.copyWith(originalBook: expectedBook);
      final state2 = state.copyWith();

      expect(state.originalBook, expectedBook);
      expect(state2.originalBook, expectedBook);
    },
  );

  test(
    'copy with image',
    () {
      final Image expectedImage = createImage(
        fileName: 'i1.jpg',
        data: Uint8List(5),
      );

      state = state.copyWith(image: expectedImage);
      final state2 = state.copyWith();

      expect(state.image, expectedImage);
      expect(state2.image, expectedImage);
    },
  );

  test(
    'copy with title',
    () {
      const String expectedTitle = 'title';

      state = state.copyWith(title: expectedTitle);
      final state2 = state.copyWith();

      expect(state.title, expectedTitle);
      expect(state2.title, expectedTitle);
    },
  );

  test(
    'copy with author',
    () {
      const String expectedAuthor = 'author';

      state = state.copyWith(author: expectedAuthor);
      final state2 = state.copyWith();

      expect(state.author, expectedAuthor);
      expect(state2.author, expectedAuthor);
    },
  );

  test(
    'copy with read pages amount',
    () {
      const int expectedReadPagesAmount = 20;

      state = state.copyWith(readPagesAmount: expectedReadPagesAmount);
      final state2 = state.copyWith();

      expect(state.readPagesAmount, expectedReadPagesAmount);
      expect(state2.readPagesAmount, expectedReadPagesAmount);
    },
  );

  test(
    'copy with all pages amount',
    () {
      const int expectedAllPagesAmount = 100;

      state = state.copyWith(allPagesAmount: expectedAllPagesAmount);
      final state2 = state.copyWith();

      expect(state.allPagesAmount, expectedAllPagesAmount);
      expect(state2.allPagesAmount, expectedAllPagesAmount);
    },
  );

  test(
    'copy with deleted image',
    () {
      final Image image = createImage(
        fileName: 'i1.jpg',
        data: Uint8List(1),
      );

      state = state.copyWith(image: image);
      final state2 = state.copyWith(deletedImage: true);

      expect(state.image, image);
      expect(state2.image, null);
    },
  );
}
