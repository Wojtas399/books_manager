import 'package:app/domain/entities/book.dart';
import 'package:app/domain/use_cases/book/get_book_by_id_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockGetBookByIdUseCase extends Mock implements GetBookByIdUseCase {
  void mock({required Book book}) {
    when(
      () => execute(
        bookId: any(named: 'bookId'),
      ),
    ).thenAnswer((_) => Stream.value(book));
  }
}
