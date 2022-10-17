import 'package:app/domain/use_cases/book/start_reading_book_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockStartReadingBookUseCase extends Mock
    implements StartReadingBookUseCase {
  void mock() {
    when(
      () => execute(
        bookId: any(named: 'bookId'),
        fromBeginning: any(named: 'fromBeginning'),
      ),
    ).thenAnswer((_) async => '');
  }
}
