import 'package:app/data/data_sources/local_db/sqlite/models/sqlite_user.dart';
import 'package:app/data/data_sources/local_db/sqlite/services/sqlite_user_service.dart';
import 'package:app/data/data_sources/local_db/sqlite/sqlite_sync_state.dart';
import 'package:mocktail/mocktail.dart';

class FakeSqliteUser extends Fake implements SqliteUser {}

class MockSqliteUserService extends Mock implements SqliteUserService {
  void mockLoadUser({SqliteUser? sqliteUser}) {
    when(
      () => loadUser(
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((_) async => sqliteUser);
  }

  void mockAddUser() {
    _mockSqliteUser();
    when(
      () => addUser(
        sqliteUser: any(named: 'sqliteUser'),
      ),
    ).thenAnswer((_) async => '');
  }

  void mockUpdateUser({SqliteUser? updatedSqliteUser}) {
    _mockSyncState();
    when(
      () => updateUser(
        userId: any(named: 'userId'),
        isDarkModeOn: any(named: 'isDarkModeOn'),
        isDarkModeCompatibilityWithSystemOn:
            any(named: 'isDarkModeCompatibilityWithSystemOn'),
        syncState: any(named: 'syncState'),
      ),
    ).thenAnswer((_) async => updatedSqliteUser);
  }

  void mockDeleteUser() {
    when(
      () => deleteUser(
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((_) async => '');
  }

  void _mockSqliteUser() {
    registerFallbackValue(FakeSqliteUser());
  }

  void _mockSyncState() {
    registerFallbackValue(SyncState.none);
  }
}
