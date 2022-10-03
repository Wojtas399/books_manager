import 'package:app/providers/date_provider.dart';
import 'package:mocktail/mocktail.dart';

class MockDateProvider extends Mock implements DateProvider {
  void mockGetNow({required DateTime nowDateTime}) {
    when(
      () => getNow(),
    ).thenReturn(nowDateTime);
  }

  void mockGetDateOfFirstDayInPreviousMonth({
    required DateTime dateOfFirstDayInPreviousMonth,
  }) {
    when(
      () => getDateOfFirstDayInPreviousMonth(
        month: any(named: 'month'),
        year: any(named: 'year'),
      ),
    ).thenReturn(dateOfFirstDayInPreviousMonth);
  }

  void mockGetDateOfFirstDayInNextMonth({
    required DateTime dateOfFirstDayInNextMonth,
  }) {
    when(
      () => getDateOfFirstDayInNextMonth(
        month: any(named: 'month'),
        year: any(named: 'year'),
      ),
    ).thenReturn(dateOfFirstDayInNextMonth);
  }
}
