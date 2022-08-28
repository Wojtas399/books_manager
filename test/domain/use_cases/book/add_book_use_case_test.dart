import 'package:app/domain/entities/book.dart';
import 'package:app/domain/use_cases/book/add_book_use_case.dart';
import 'package:app/interfaces/book_interface.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockBookInterface extends Mock implements BookInterface {}

void main() {
  final bookInterface = MockBookInterface();
  final useCase = AddBookUseCase(bookInterface: bookInterface);

  test(
    'should call method responsible for adding new book',
    () async {
      final Book book = createBook(userId: 'u1', title: 'book 1');
      when(
        () => bookInterface.addNewBook(book: book),
      ).thenAnswer((_) async => '');

      await useCase.execute(book: book);

      verify(
        () => bookInterface.addNewBook(book: book),
      ).called(1);
    },
  );
}
