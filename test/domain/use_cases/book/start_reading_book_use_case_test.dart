import 'package:app/domain/entities/book.dart';
import 'package:app/domain/interfaces/book_interface.dart';
import 'package:app/domain/use_cases/book/start_reading_book_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockBookInterface extends Mock implements BookInterface {}

void main() {
  final bookInterface = MockBookInterface();
  final useCase = StartReadingBookUseCase(bookInterface: bookInterface);

  test(
    'should update book with status set as in progress',
    () async {
      const String bookId = 'b1';
      const String userId = 'u1';
      when(
        () => bookInterface.updateBookData(
          bookId: bookId,
          userId: userId,
          bookStatus: BookStatus.inProgress,
        ),
      ).thenAnswer((_) async => '');

      await useCase.execute(bookId: bookId, userId: userId);

      verify(
        () => bookInterface.updateBookData(
          bookId: bookId,
          userId: userId,
          bookStatus: BookStatus.inProgress,
        ),
      ).called(1);
    },
  );
}
