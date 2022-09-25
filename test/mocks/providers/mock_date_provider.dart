import 'package:app/providers/date_provider.dart';
import 'package:mocktail/mocktail.dart';

class MockDateProvider extends Mock implements DateProvider {
  void mockGetNow({required DateTime nowDateTime}) {
    when(
      () => getNow(),
    ).thenReturn(nowDateTime);
  }
}
