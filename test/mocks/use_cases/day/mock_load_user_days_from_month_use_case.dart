import 'package:app/domain/use_cases/day/load_user_days_from_month_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockLoadUserDaysFromMonthUseCase extends Mock
    implements LoadUserDaysFromMonthUseCase {
  void mock() {
    when(
      () => execute(
        userId: any(named: 'userId'),
        month: any(named: 'month'),
        year: any(named: 'year'),
      ),
    ).thenAnswer((_) async => '');
  }
}
