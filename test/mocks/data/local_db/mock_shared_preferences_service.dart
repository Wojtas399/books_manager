import 'package:app/data/data_sources/local_db/shared_preferences_service.dart';
import 'package:mocktail/mocktail.dart';

class MockSharedPreferencesService extends Mock
    implements SharedPreferencesService {
  void mockSaveLoggedUserId() {
    when(
      () => saveLoggedUserId(
        loggedUserId: any(named: 'loggedUserId'),
      ),
    ).thenAnswer((_) async => '');
  }

  void mockLoadLoggedUserId({String? loggedUserId}) {
    when(
      () => loadLoggedUserId(),
    ).thenAnswer((_) async => loggedUserId);
  }

  void mockRemoveLoggedUserId() {
    when(
      () => removeLoggedUserId(),
    ).thenAnswer((_) async => '');
  }
}
