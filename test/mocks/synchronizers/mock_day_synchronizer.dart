import 'package:app/data/synchronizers/day_synchronizer.dart';
import 'package:mocktail/mocktail.dart';

class MockDaySynchronizer extends Mock implements DaySynchronizer {
  void mockSynchronizeUserUnmodifiedDays() {
    when(
      () => synchronizeUserUnmodifiedDays(
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((_) async => '');
  }

  void mockSynchronizeUserDaysMarkedAsAdded() {
    when(
      () => synchronizeUserDaysMarkedAsAdded(
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((_) async => '');
  }

  void mockSynchronizeUserDaysMarkedAsUpdated() {
    when(
      () => synchronizeUserDaysMarkedAsUpdated(
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((_) async => '');
  }
}
