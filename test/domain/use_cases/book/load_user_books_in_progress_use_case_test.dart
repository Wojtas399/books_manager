import 'package:app/domain/entities/book.dart';
import 'package:app/domain/interfaces/book_interface.dart';
import 'package:app/domain/use_cases/book/load_user_books_in_progress_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockBookInterface extends Mock implements BookInterface {}

void main() {
  final bookInterface = MockBookInterface();
  final useCase = LoadUserBooksInProgressUseCase(bookInterface: bookInterface);

  test(
    'should call method responsible for loading user books with status set as in progress',
    () async {
      const String userId = 'u1';
      when(
        () => bookInterface.loadUserBooks(
          userId: userId,
          bookStatus: BookStatus.inProgress,
        ),
      ).thenAnswer((_) async => '');

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
