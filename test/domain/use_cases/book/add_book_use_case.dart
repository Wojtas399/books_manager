import 'package:app/domain/use_cases/book/add_book_use_case.dart';
import 'package:app/interfaces/book_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockBookInterface extends Mock implements BookInterface {}

void main() {
  final bookInterface = MockBookInterface();
  final useCase = AddBookUseCase(bookInterface: bookInterface);

  test(
    'should call method responsible for adding new book',
    () async {
      const String title = 'title';
      const String author = 'author';
      const int readPagesAmount = 30;
      const int allPagesAmount = 200;
      when(
        () => bookInterface.addNewBook(
          title: title,
          author: author,
          readPagesAmount: readPagesAmount,
          allPagesAmount: allPagesAmount,
        ),
      ).thenAnswer((_) async => '');

      await useCase.execute(
        title: title,
        author: author,
        readPagesAmount: readPagesAmount,
        allPagesAmount: allPagesAmount,
      );

      verify(
        () => bookInterface.addNewBook(
          title: title,
          author: author,
          readPagesAmount: readPagesAmount,
          allPagesAmount: allPagesAmount,
        ),
      ).called(1);
    },
  );
}
