import 'package:app/domain/entities/book.dart';
import 'package:app/domain/use_cases/book/get_book_by_id_use_case.dart';
import 'package:app/interfaces/book_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockBookInterface extends Mock implements BookInterface {}

void main() {
  final bookInterface = MockBookInterface();
  final useCase = GetBookByIdUseCase(bookInterface: bookInterface);

  test(
    'should return stream which contains book with given id',
    () async {
      const String bookId = 'b1';
      final Book expectedBook = createBook(id: bookId);
      when(
        () => bookInterface.getBookById(bookId: bookId),
      ).thenAnswer((_) => Stream.value(expectedBook));

      final Stream<Book> book$ = useCase.execute(bookId: bookId);

      expect(await book$.first, expectedBook);
    },
  );
}
