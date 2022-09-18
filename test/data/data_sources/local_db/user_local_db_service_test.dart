import 'package:app/data/data_sources/local_db/sqlite/models/sqlite_user.dart';
import 'package:app/data/data_sources/local_db/sqlite/services/sqlite_user_service.dart';
import 'package:app/data/data_sources/local_db/sqlite/sqlite_sync_state.dart';
import 'package:app/data/data_sources/local_db/user_local_db_service.dart';
import 'package:app/data/models/db_user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSqliteUserService extends Mock implements SqliteUserService {}

class FakeSqliteUser extends Fake implements SqliteUser {}

void main() {
  final sqliteUserService = MockSqliteUserService();
  late UserLocalDbService service;

  setUpAll(() {
    registerFallbackValue(FakeSqliteUser());
  });

  setUp(() {
    service = UserLocalDbService(
      sqliteUserService: sqliteUserService,
    );
  });

  tearDown(() {
    reset(sqliteUserService);
  });

  test(
    'load user, should load user from sqlite',
    () async {
      const String userId = 'u1';
      final SqliteUser sqliteUser = createSqliteUser(id: userId);
      final DbUser expectedDbUser = createDbUser(
        id: sqliteUser.id,
        isDarkModeOn: sqliteUser.isDarkModeOn,
        isDarkModeCompatibilityWithSystemOn:
            sqliteUser.isDarkModeCompatibilityWithSystemOn,
      );
      when(
        () => sqliteUserService.loadUser(userId: userId),
      ).thenAnswer((_) async => sqliteUser);

      final DbUser dbUser = await service.loadUser(userId: userId);

      expect(dbUser, expectedDbUser);
    },
  );

  group(
    'add user',
    () {
      final DbUser dbUser = createDbUser(id: 'u1');
      SqliteUser sqliteUser = createSqliteUser(
        id: dbUser.id,
        isDarkModeOn: dbUser.isDarkModeOn,
        isDarkModeCompatibilityWithSystemOn:
            dbUser.isDarkModeCompatibilityWithSystemOn,
        syncState: SyncState.none,
      );

      setUp(() {
        when(
          () => sqliteUserService.addUser(
            sqliteUser: any(named: 'sqliteUser'),
          ),
        ).thenAnswer((_) async => '');
      });

      test(
        'should call method responsible for adding user to sqlite with sync state set as none by default',
        () async {
          await service.addUser(dbUser: dbUser);

          verify(
            () => sqliteUserService.addUser(sqliteUser: sqliteUser),
          ).called(1);
        },
      );

      test(
        'should call method responsible for adding user to sqlite with sync state given as second param',
        () async {
          const SyncState syncState = SyncState.added;
          sqliteUser = sqliteUser.copyWith(syncState: syncState);
          Future<void> addMethodCall() =>
              sqliteUserService.addUser(sqliteUser: sqliteUser);
          when(addMethodCall).thenAnswer((_) async => '');

          await service.addUser(dbUser: dbUser, syncState: syncState);

          verify(addMethodCall).called(1);
        },
      );
    },
  );

  test(
    'update user, should call method responsible for updating user in sqlite and should return updated user',
    () async {
      const String userId = 'u1';
      const bool isDarkModeOn = false;
      const bool isDarkModeCompatibilityWithSystemOn = true;
      const SyncState syncState = SyncState.updated;
      final SqliteUser updatedSqliteUser = createSqliteUser(
        id: userId,
        isDarkModeOn: isDarkModeOn,
        isDarkModeCompatibilityWithSystemOn:
            isDarkModeCompatibilityWithSystemOn,
        syncState: syncState,
      );
      final DbUser expectedUpdatedDbUser = createDbUser(
        id: userId,
        isDarkModeOn: isDarkModeOn,
        isDarkModeCompatibilityWithSystemOn:
            isDarkModeCompatibilityWithSystemOn,
      );
      Future<SqliteUser> updateMethodCall() => sqliteUserService.updateUser(
            userId: userId,
            isDarkModeOn: isDarkModeOn,
            isDarkModeCompatibilityWithSystemOn:
                isDarkModeCompatibilityWithSystemOn,
            syncState: syncState,
          );
      when(updateMethodCall).thenAnswer((_) async => updatedSqliteUser);

      final DbUser updatedDbUser = await service.updateUser(
        userId: userId,
        isDarkModeOn: isDarkModeOn,
        isDarkModeCompatibilityWithSystemOn:
            isDarkModeCompatibilityWithSystemOn,
        syncState: syncState,
      );

      expect(updatedDbUser, expectedUpdatedDbUser);
      verify(updateMethodCall).called(1);
    },
  );

  test(
    'delete user, should call method responsible for deleting user',
    () async {
      const String userId = 'u1';
      Future<void> deleteMethodCall() =>
          sqliteUserService.deleteUser(userId: userId);
      when(deleteMethodCall).thenAnswer((_) async => '');

      await service.deleteUser(userId: userId);

      verify(deleteMethodCall).called(1);
    },
  );
}
