import 'package:app/features/book_creator/bloc/book_creator_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late BookCreatorState state;

  setUp(() {
    state = const BookCreatorState(
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
    'copy with image path',
    () {
      const String expectedPath = 'path';

      state = state.copyWith(imagePath: expectedPath);
      final state2 = state.copyWith();

      expect(state.imagePath, expectedPath);
      expect(state2.imagePath, expectedPath);
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
    'copy with removed image path',
    () {
      state = state.copyWith(imagePath: 'path');
      final state2 = state.copyWith(removedImagePath: true);

      expect(state.imagePath, 'path');
      expect(state2.imagePath, null);
    },
  );
}
