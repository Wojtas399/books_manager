import 'package:app/data/data_sources/local_db/sqlite/sqlite_sync_state.dart';
import 'package:app/data/data_sources/local_db/user_local_db_service.dart';
import 'package:app/domain/entities/user.dart';
import 'package:mocktail/mocktail.dart';

class FakeUser extends Fake implements User {}

class MockUserLocalDbService extends Mock implements UserLocalDbService {
  void mockDoesUserExist({required bool doesExist}) {
    when(
      () => doesUserExist(
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((_) async => doesExist);
  }

  void mockLoadUser({required User user}) {
    when(
      () => loadUser(
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((_) async => user);
  }

  void mockLoadUserSyncState({required SyncState syncState}) {
    when(
      () => loadUserSyncState(
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((_) async => syncState);
  }

  void mockAddUser() {
    _mockUser();
    _mockSyncState();
    when(
      () => addUser(
        user: any(named: 'user'),
        syncState: any(named: 'syncState'),
      ),
    ).thenAnswer((_) async => '');
  }

  void mockUpdateUser({required User updatedUser}) {
    _mockSyncState();
    when(
      () => updateUser(
        userId: any(named: 'userId'),
        isDarkModeOn: any(named: 'isDarkModeOn'),
        isDarkModeCompatibilityWithSystemOn:
            any(named: 'isDarkModeCompatibilityWithSystemOn'),
        syncState: any(named: 'syncState'),
      ),
    ).thenAnswer((_) async => updatedUser);
  }

  void mockDeleteUser() {
    when(
      () => deleteUser(
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((_) async => '');
  }

  void _mockUser() {
    registerFallbackValue(FakeUser());
  }

  void _mockSyncState() {
    registerFallbackValue(SyncState.none);
  }
}
