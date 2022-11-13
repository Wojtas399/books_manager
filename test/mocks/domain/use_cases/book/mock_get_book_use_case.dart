import 'package:app/domain/entities/book.dart';
import 'package:app/domain/use_cases/book/get_book_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockGetBookUseCase extends Mock implements GetBookUseCase {
  void mock({required Book book}) {
    when(
      () => execute(
        bookId: any(named: 'bookId'),
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((_) => Stream.value(book));
  }
}
