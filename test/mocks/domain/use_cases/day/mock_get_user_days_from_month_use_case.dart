import 'package:app/domain/entities/day.dart';
import 'package:app/domain/use_cases/day/get_user_days_from_month_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockGetUserDaysFromMonthUseCase extends Mock
    implements GetUserDaysFromMonthUseCase {
  void mock({List<Day>? userDaysFromMonth}) {
    when(
      () => execute(
        userId: any(named: 'userId'),
        month: any(named: 'month'),
        year: any(named: 'year'),
      ),
    ).thenAnswer((_) => Stream.value(userDaysFromMonth));
  }
}
