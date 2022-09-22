import 'package:app/data/data_sources/local_db/auth_local_db_service.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthLocalDbService extends Mock implements AuthLocalDbService {
  void mockLoadLoggedUserId({String? loggedUserId}) {
    when(
      () => loadLoggedUserId(),
    ).thenAnswer((_) async => loggedUserId);
  }

  void mockSaveLoggedUserId() {
    when(
      () => saveLoggedUserId(
        loggedUserId: any(named: 'loggedUserId'),
      ),
    ).thenAnswer((_) async => '');
  }

  void mockRemoveLoggedUserId() {
    when(
      () => removeLoggedUserId(),
    ).thenAnswer((_) async => '');
  }
}
