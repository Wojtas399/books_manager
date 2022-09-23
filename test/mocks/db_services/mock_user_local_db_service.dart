import 'package:app/data/data_sources/local_db/sqlite/sqlite_sync_state.dart';
import 'package:app/data/data_sources/local_db/user_local_db_service.dart';
import 'package:app/data/models/db_user.dart';
import 'package:mocktail/mocktail.dart';

class FakeDbUser extends Fake implements DbUser {}

class MockUserLocalDbService extends Mock implements UserLocalDbService {
  void mockDoesUserExist({required bool doesExist}) {
    when(
      () => doesUserExist(
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((_) async => doesExist);
  }

  void mockLoadUser({required DbUser dbUser}) {
    when(
      () => loadUser(
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((_) async => dbUser);
  }

  void mockLoadUserSyncState({required SyncState syncState}) {
    when(
      () => loadUserSyncState(
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((_) async => syncState);
  }

  void mockAddUser() {
    _mockDbUser();
    _mockSyncState();
    when(
      () => addUser(
        dbUser: any(named: 'dbUser'),
        syncState: any(named: 'syncState'),
      ),
    ).thenAnswer((_) async => '');
  }

  void mockUpdateUser({required DbUser updatedDbUser}) {
    _mockSyncState();
    when(
      () => updateUser(
        userId: any(named: 'userId'),
        isDarkModeOn: any(named: 'isDarkModeOn'),
        isDarkModeCompatibilityWithSystemOn:
            any(named: 'isDarkModeCompatibilityWithSystemOn'),
        syncState: any(named: 'syncState'),
      ),
    ).thenAnswer((_) async => updatedDbUser);
  }

  void mockDeleteUser() {
    when(
      () => deleteUser(
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((_) async => '');
  }

  void _mockDbUser() {
    registerFallbackValue(FakeDbUser());
  }

  void _mockSyncState() {
    registerFallbackValue(SyncState.none);
  }
}
