import 'package:app/domain/use_cases/book/update_current_page_number_after_reading_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockUpdateCurrentPageNumberAfterReadingUseCase extends Mock
    implements UpdateCurrentPageNumberAfterReadingUseCase {
  void mock({Object? throwable}) {
    if (throwable != null) {
      when(_useCaseCall).thenThrow(throwable);
    } else {
      when(_useCaseCall).thenAnswer((_) async => '');
    }
  }

  Future<void> _useCaseCall() {
    return execute(
      userId: any(named: 'userId'),
      bookId: any(named: 'bookId'),
      newCurrentPageNumber: any(named: 'newCurrentPageNumber'),
    );
  }
}
