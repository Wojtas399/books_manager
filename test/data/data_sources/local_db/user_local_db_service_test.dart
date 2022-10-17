import 'package:app/config/errors.dart';
import 'package:app/data/data_sources/local_db/sqlite/models/sqlite_user.dart';
import 'package:app/data/data_sources/local_db/sqlite/sqlite_sync_state.dart';
import 'package:app/data/data_sources/local_db/user_local_db_service.dart';
import 'package:app/domain/entities/user.dart';
import 'package:app/models/error.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks/data/local_db/sqlite/mock_sqlite_user_service.dart';

void main() {
  final sqliteUserService = MockSqliteUserService();
  late UserLocalDbService service;

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

      Future<bool> callDoesUserExistMethod() async {
        return await service.doesUserExist(userId: userId);
      }

      test(
        'user loaded from sqlite is not null, should return true,',
        () async {
          sqliteUserService.mockLoadUser(sqliteUser: createSqliteUser());

          final bool doesUserExist = await callDoesUserExistMethod();

          expect(doesUserExist, true);
        },
      );

      test(
        'user loaded from sqlite is null, should return false',
        () async {
          sqliteUserService.mockLoadUser();

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

      Future<User> callLoadUserMethod() async {
        return await service.loadUser(userId: userId);
      }

      test(
        'user loaded from sqlite is not null, should return user mapped from loaded sqlite user',
        () async {
          final SqliteUser sqliteUser = createSqliteUser(id: userId);
          final User expectedUser = createUser(
            id: sqliteUser.id,
            isDarkModeOn: sqliteUser.isDarkModeOn,
            isDarkModeCompatibilityWithSystemOn:
                sqliteUser.isDarkModeCompatibilityWithSystemOn,
          );
          sqliteUserService.mockLoadUser(sqliteUser: sqliteUser);

          final User user = await callLoadUserMethod();

          expect(user, expectedUser);
        },
      );

      test(
        'user loaded from sqlite is null, should throw user error',
        () async {
          sqliteUserService.mockLoadUser();

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
          sqliteUserService.mockLoadUser(sqliteUser: sqliteUser);

          final SyncState syncState = await callLoadUserSyncStateMethod();

          expect(syncState, expectedSyncState);
        },
      );

      test(
        'user loaded from sqlite is null, should throw user error',
        () async {
          sqliteUserService.mockLoadUser();

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
      final User user = createUser(id: 'u1');
      SqliteUser sqliteUser = createSqliteUser(
        id: user.id,
        isDarkModeOn: user.isDarkModeOn,
        isDarkModeCompatibilityWithSystemOn:
            user.isDarkModeCompatibilityWithSystemOn,
        syncState: SyncState.none,
      );

      Future<void> callAddMethod({
        SyncState syncState = SyncState.none,
      }) async {
        await service.addUser(user: user, syncState: syncState);
      }

      setUp(() {
        sqliteUserService.mockAddUser();
      });

      test(
        'should call method responsible for adding user to sqlite with sync state set as none by default',
        () async {
          await callAddMethod();

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

          await callAddMethod(syncState: syncState);

          verify(
            () => sqliteUserService.addUser(sqliteUser: sqliteUser),
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

      Future<User> callUpdateUserMethod() async {
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
          final User expectedUpdatedUser = createUser(
            id: userId,
            isDarkModeOn: isDarkModeOn,
            isDarkModeCompatibilityWithSystemOn:
                isDarkModeCompatibilityWithSystemOn,
          );
          sqliteUserService.mockUpdateUser(
            updatedSqliteUser: updatedSqliteUser,
          );

          final User updatedUser = await callUpdateUserMethod();

          expect(updatedUser, expectedUpdatedUser);
          verify(
            () => sqliteUserService.updateUser(
              userId: userId,
              isDarkModeOn: isDarkModeOn,
              isDarkModeCompatibilityWithSystemOn:
                  isDarkModeCompatibilityWithSystemOn,
              syncState: syncState,
            ),
          ).called(1);
        },
      );

      test(
        'should call method responsible for updating user in sqlite and should throw user error if returned user is null',
        () async {
          sqliteUserService.mockUpdateUser();

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
