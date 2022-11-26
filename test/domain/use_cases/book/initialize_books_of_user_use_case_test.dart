import 'package:app/domain/use_cases/book/initialize_books_of_user_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks/domain/interfaces/mock_book_interface.dart';

void main() {
  final bookInterface = MockBookInterface();
  final useCase = InitializeBooksOfUserUseCase(bookInterface: bookInterface);

  test(
    'should call method responsible for initializing user books',
    () async {
      const String userId = 'u1';

      useCase.execute(userId: userId);

      verify(
        () => bookInterface.initializeBooksOfUser(userId: userId),
      ).called(1);
    },
  );
}
