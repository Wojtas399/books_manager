import 'package:app/domain/interfaces/book_interface.dart';
import 'package:app/domain/use_cases/book/load_all_user_books_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockBookInterface extends Mock implements BookInterface {}

void main() {
  final bookInterface = MockBookInterface();
  final useCase = LoadAllUserBooksUseCase(bookInterface: bookInterface);

  test(
    'should call methods responsible for loading all books belonging to user',
    () async {
      const String userId = 'u1';
      when(
        () => bookInterface.loadUserBooks(userId: userId),
      ).thenAnswer((_) async => '');

      await useCase.execute(userId: userId);

      verify(
        () => bookInterface.loadUserBooks(userId: userId),
      ).called(1);
    },
  );
}
