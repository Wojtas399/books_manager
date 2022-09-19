import 'package:app/config/errors.dart';
import 'package:app/data/data_sources/local_db/sqlite/models/sqlite_user.dart';
import 'package:app/data/data_sources/local_db/sqlite/services/sqlite_user_service.dart';
import 'package:app/data/data_sources/local_db/sqlite/sqlite_sync_state.dart';
import 'package:app/data/data_sources/local_db/user_local_db_service.dart';
import 'package:app/data/models/db_user.dart';
import 'package:app/models/error.dart';
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

  group(
    'does user exist',
    () {
      const String userId = 'u1';

      Future<SqliteUser?> sqliteLoadUserMethodCall() {
        return sqliteUserService.loadUser(userId: userId);
      }

      Future<bool> callDoesUserExistMethod() async {
        return await service.doesUserExist(userId: userId);
      }

      test(
        'user loaded from sqlite is not null, should return true,',
        () async {
          when(
            sqliteLoadUserMethodCall,
          ).thenAnswer((_) async => createSqliteUser());

          final bool doesUserExist = await callDoesUserExistMethod();

          expect(doesUserExist, true);
        },
      );

      test(
        'user loaded from sqlite is null, should return false',
        () async {
          when(sqliteLoadUserMethodCall).thenAnswer((_) async => null);

          final bool doesUserExist = await callDoesUserExistMethod();

          expect(doesUserExist, false);
        },
      );
    },
  );

  group(
    'load user',
    () {
      const String userId = 'u1';

      Future<SqliteUser?> sqliteLoadUserMethodCall() {
        return sqliteUserService.loadUser(userId: userId);
      }

      Future<DbUser> callLoadUserMethod() async {
        return await service.loadUser(userId: userId);
      }

      test(
        'user loaded from sqlite is not null, should return db user mapped from loaded sqlite user',
        () async {
          final SqliteUser sqliteUser = createSqliteUser(id: userId);
          final DbUser expectedDbUser = createDbUser(
            id: sqliteUser.id,
            isDarkModeOn: sqliteUser.isDarkModeOn,
            isDarkModeCompatibilityWithSystemOn:
                sqliteUser.isDarkModeCompatibilityWithSystemOn,
          );
          when(sqliteLoadUserMethodCall).thenAnswer((_) async => sqliteUser);

          final DbUser dbUser = await callLoadUserMethod();

          expect(dbUser, expectedDbUser);
        },
      );

      test(
        'user loaded from sqlite is null, should throw user error',
        () async {
          when(sqliteLoadUserMethodCall).thenAnswer((_) async => null);

          try {
            await callLoadUserMethod();
          } on UserError catch (userError) {
            expect(
              userError,
              const UserError(code: UserErrorCode.userNotFound),
            );
          }
        },
      );
    },
  );

  group(
    'load user sync state',
    () {
      const String userId = 'u1';

      Future<SqliteUser?> sqliteLoadUserMethodCall() {
        return sqliteUserService.loadUser(userId: userId);
      }

      Future<SyncState> callLoadUserSyncStateMethod() async {
        return await service.loadUserSyncState(userId: userId);
      }

      test(
        'user loaded from sqlite is not null, should return sync state of loaded sqlite user',
        () async {
          const SyncState expectedSyncState = SyncState.updated;
          final SqliteUser sqliteUser = createSqliteUser(
            id: userId,
            syncState: expectedSyncState,
          );
          when(sqliteLoadUserMethodCall).thenAnswer((_) async => sqliteUser);

          final SyncState syncState = await callLoadUserSyncStateMethod();

          expect(syncState, expectedSyncState);
        },
      );

      test(
        'user loaded from sqlite is null, should throw user error',
        () async {
          when(sqliteLoadUserMethodCall).thenAnswer((_) async => null);

          try {
            await callLoadUserSyncStateMethod();
          } on UserError catch (userError) {
            expect(
              userError,
              const UserError(code: UserErrorCode.userNotFound),
            );
          }
        },
      );
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

      Future<void> sqliteAddUserMethodCall({SqliteUser? sqliteUserToAdd}) {
        return sqliteUserService.addUser(
          sqliteUser: sqliteUserToAdd ?? any(named: 'sqliteUser'),
        );
      }

      Future<void> callAddMethod({
        SyncState syncState = SyncState.none,
      }) async {
        await service.addUser(dbUser: dbUser, syncState: syncState);
      }

      test(
        'should call method responsible for adding user to sqlite with sync state set as none by default',
        () async {
          when(sqliteAddUserMethodCall).thenAnswer((_) async => '');

          await callAddMethod();

          verify(
            () => sqliteAddUserMethodCall(sqliteUserToAdd: sqliteUser),
          ).called(1);
        },
      );

      test(
        'should call method responsible for adding user to sqlite with sync state given as second param',
        () async {
          const SyncState syncState = SyncState.added;
          sqliteUser = sqliteUser.copyWith(syncState: syncState);
          when(
            () => sqliteAddUserMethodCall(sqliteUserToAdd: sqliteUser),
          ).thenAnswer((_) async => '');

          await callAddMethod(syncState: syncState);

          verify(
            () => sqliteAddUserMethodCall(sqliteUserToAdd: sqliteUser),
          ).called(1);
        },
      );
    },
  );

  group(
    'update user',
    () {
      const String userId = 'u1';
      const bool isDarkModeOn = false;
      const bool isDarkModeCompatibilityWithSystemOn = true;
      const SyncState syncState = SyncState.updated;

      Future<SqliteUser?> sqliteUpdateUserMethodCal() {
        return sqliteUserService.updateUser(
          userId: userId,
          isDarkModeOn: isDarkModeOn,
          isDarkModeCompatibilityWithSystemOn:
              isDarkModeCompatibilityWithSystemOn,
          syncState: syncState,
        );
      }

      Future<DbUser> callUpdateUserMethod() async {
        return await service.updateUser(
          userId: userId,
          isDarkModeOn: isDarkModeOn,
          isDarkModeCompatibilityWithSystemOn:
              isDarkModeCompatibilityWithSystemOn,
          syncState: syncState,
        );
      }

      test(
        'should call method responsible for updating user in sqlite and should return updated user',
        () async {
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
          when(
            sqliteUpdateUserMethodCal,
          ).thenAnswer((_) async => updatedSqliteUser);

          final DbUser updatedDbUser = await callUpdateUserMethod();

          expect(updatedDbUser, expectedUpdatedDbUser);
          verify(sqliteUpdateUserMethodCal).called(1);
        },
      );

      test(
        'should call method responsible for updating user in sqlite and should throw user error if returned user is null',
        () async {
          when(
            sqliteUpdateUserMethodCal,
          ).thenAnswer((_) async => null);

          try {
            await callUpdateUserMethod();
          } on UserError catch (userError) {
            expect(
              userError,
              const UserError(code: UserErrorCode.updateFailure),
            );
          }
        },
      );
    },
  );

  test(
    'delete user, should call method responsible for deleting user',
    () async {
      const String userId = 'u1';
      Future<void> deleteMethodCall() {
        return sqliteUserService.deleteUser(userId: userId);
      }

      when(deleteMethodCall).thenAnswer((_) async => '');

      await service.deleteUser(userId: userId);

      verify(deleteMethodCall).called(1);
    },
  );
}
