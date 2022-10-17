import 'package:app/domain/entities/book.dart';
import 'package:app/domain/use_cases/book/load_user_books_in_progress_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks/interfaces/mock_book_interface.dart';

void main() {
  final bookInterface = MockBookInterface();
  final useCase = LoadUserBooksInProgressUseCase(bookInterface: bookInterface);

  test(
    'should call method responsible for loading user books with status set as in progress',
    () async {
      const String userId = 'u1';
      bookInterface.mockLoadUserBooks();

      await useCase.execute(userId: userId);

      verify(
        () => bookInterface.loadUserBooks(
          userId: userId,
          bookStatus: BookStatus.inProgress,
        ),
      ).called(1);
    },
  );
}
