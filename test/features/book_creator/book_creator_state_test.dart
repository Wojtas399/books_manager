import 'dart:typed_data';

import 'package:app/features/book_creator/bloc/book_creator_bloc.dart';
import 'package:app/models/bloc_status.dart';
import 'package:app/models/image.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late BookCreatorState state;

  setUp(() {
    state = const BookCreatorState(
      status: BlocStatusInitial(),
      image: null,
      title: '',
      author: '',
      allPagesAmount: 0,
      readPagesAmount: 0,
    );
  });

  test(
    'is button disabled, should be false if title and author are not empty, if all pages amount is higher than 0 and if read pages amount is lower or equal to all pages amount',
    () {
      state = state.copyWith(
        title: 'title',
        author: 'author',
        readPagesAmount: 20,
        allPagesAmount: 300,
      );

      expect(state.isButtonDisabled, false);
    },
  );

  test(
    'is button disabled, should be true if title is empty',
    () {
      state = state.copyWith(
        title: '',
        author: 'author',
        readPagesAmount: 20,
        allPagesAmount: 300,
      );

      expect(state.isButtonDisabled, true);
    },
  );

  test(
    'is button disabled, should be true if author is empty',
    () {
      state = state.copyWith(
        title: 'title',
        author: '',
        readPagesAmount: 20,
        allPagesAmount: 300,
      );

      expect(state.isButtonDisabled, true);
    },
  );

  test(
    'is button disabled, should be true if all pages amount is equal to 0',
    () {
      state = state.copyWith(
        title: 'title',
        author: 'author',
        readPagesAmount: 0,
        allPagesAmount: 0,
      );

      expect(state.isButtonDisabled, true);
    },
  );

  test(
    'is button disabled, should be true if all pages amount is lower than read pages amount',
    () {
      state = state.copyWith(
        title: 'title',
        author: 'author',
        readPagesAmount: 200,
        allPagesAmount: 30,
      );

      expect(state.isButtonDisabled, true);
    },
  );

  test(
    'copy with bloc status',
    () {
      const BlocStatus expectedStatus = BlocStatusLoading();

      state = state.copyWith(status: expectedStatus);
      final state2 = state.copyWith();

      expect(state.status, expectedStatus);
      expect(state2.status, const BlocStatusInProgress());
    },
  );

  test(
    'copy with image',
    () {
      final Image expectedImage = createImage(
        fileName: 'i1.jpg',
        data: Uint8List(10),
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
      const int expectedAmount = 10;

      state = state.copyWith(readPagesAmount: expectedAmount);
      final state2 = state.copyWith();

      expect(state.readPagesAmount, expectedAmount);
      expect(state2.readPagesAmount, expectedAmount);
    },
  );

  test(
    'copy with all pages amount',
    () {
      const int expectedAmount = 20;

      state = state.copyWith(allPagesAmount: expectedAmount);
      final state2 = state.copyWith();

      expect(state.allPagesAmount, expectedAmount);
      expect(state2.allPagesAmount, expectedAmount);
    },
  );

  test(
    'copy with deleted image',
    () {
      final Image image = createImage(
        fileName: 'i1.jpg',
        data: Uint8List(10),
      );
      state = state.copyWith(image: image);
      final state2 = state.copyWith(deletedImage: true);

      expect(state.image, image);
      expect(state2.image, null);
    },
  );
}
