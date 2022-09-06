import 'package:app/domain/use_cases/book/delete_book_use_case.dart';
import 'package:app/interfaces/book_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockBookInterface extends Mock implements BookInterface {}

void main() {
  final bookInterface = MockBookInterface();
  final useCase = DeleteBookUseCase(bookInterface: bookInterface);

  test(
    'should call method responsible for deleting book',
    () async {
      const String userId = 'u1';
      const String bookId = 'b1';
      when(
        () => bookInterface.deleteBook(userId: userId, bookId: bookId),
      ).thenAnswer((_) async => '');

      await useCase.execute(userId: userId, bookId: bookId);

      verify(
        () => bookInterface.deleteBook(userId: userId, bookId: bookId),
      ).called(1);
    },
  );
}
