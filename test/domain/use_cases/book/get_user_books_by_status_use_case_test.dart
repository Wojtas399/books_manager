import 'package:app/domain/entities/book.dart';
import 'package:app/domain/interfaces/book_interface.dart';
import 'package:app/domain/use_cases/book/get_user_books_by_status_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockBookInterface extends Mock implements BookInterface {}

void main() {
  final bookInterface = MockBookInterface();
  final useCase = GetUserBooksByStatusUseCase(bookInterface: bookInterface);

  test(
    'should return stream which contains books matching to given status',
    () async {
      const String userId = 'u1';
      final List<Book> userBooks = [
        createBook(id: 'b1', status: BookStatus.unread),
        createBook(id: 'b2', status: BookStatus.inProgress),
        createBook(id: 'b3', status: BookStatus.finished),
        createBook(id: 'b4', status: BookStatus.inProgress),
      ];
      final List<Book> expectedBooks = [userBooks[1], userBooks[3]];
      when(
        () => bookInterface.getBooksByUserId(userId: userId),
      ).thenAnswer((_) => Stream.value(userBooks));

      final Stream<List<Book>> books$ = useCase.execute(
        userId: userId,
        bookStatus: BookStatus.inProgress,
      );

      expect(await books$.first, expectedBooks);
    },
  );
}
