import 'package:app/data/data_sources/local_db/sqlite/sqlite_sync_state.dart';
import 'package:app/data/synchronizers/user_synchronizer.dart';
import 'package:app/domain/entities/user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/local_db/mock_user_local_db_service.dart';
import '../../mocks/remote_db/mock_user_remote_db_service.dart';

void main() {
  final userLocalDbService = MockUserLocalDbService();
  final userRemoteDbService = MockUserRemoteDbService();
  late UserSynchronizer synchronizer;

  setUp(() {
    synchronizer = UserSynchronizer(
      userLocalDbService: userLocalDbService,
      userRemoteDbService: userRemoteDbService,
    );
  });

  tearDown(() {
    reset(userLocalDbService);
    reset(userRemoteDbService);
  });

  group(
    'synchronize user',
    () {
      const String userId = 'u1';
      final User user = createUser(id: userId);

      Future<User> localDbUpdateUserMethodCall({
        bool? isDarkModeOn,
        bool? isDarkModeCompatibilityWithSystemOn,
        SyncState? syncState,
      }) {
        return userLocalDbService.updateUser(
          userId: userId,
          isDarkModeOn: isDarkModeOn,
          isDarkModeCompatibilityWithSystemOn:
              isDarkModeCompatibilityWithSystemOn,
          syncState: syncState,
        );
      }

      Future<void> callSynchronizeUserMethod() async {
        await synchronizer.synchronizeUser(userId: userId);
      }

      setUp(() {
        userLocalDbService.mockUpdateUser(updatedUser: user);
      });

      test(
        'user does not exist in local db, should load user from remote db and add him to local db',
        () async {
          userLocalDbService.mockDoesUserExist(doesExist: false);
          userRemoteDbService.mockLoadUser(user: user);
          userLocalDbService.mockAddUser();

          await callSynchronizeUserMethod();

          verify(
            () => userLocalDbService.addUser(user: user),
          ).called(1);
        },
      );

      test(
        'user exists in local db, sync state is added, should load user from local db, add him to remote db and update sync state in local db to none',
        () async {
          userLocalDbService.mockDoesUserExist(doesExist: true);
          userLocalDbService.mockLoadUserSyncState(syncState: SyncState.added);
          userLocalDbService.mockLoadUser(user: user);
          userRemoteDbService.mockAddUser();

          await callSynchronizeUserMethod();

          verify(
            () => userRemoteDbService.addUser(user: user),
          ).called(1);
          verify(
            () => localDbUpdateUserMethodCall(syncState: SyncState.none),
          ).called(1);
        },
      );

      test(
        'user exists in local db, sync state is updated, should load user from local db, update him in remote db and update sync state in local db to none',
        () async {
          userLocalDbService.mockDoesUserExist(doesExist: true);
          userLocalDbService.mockLoadUserSyncState(
            syncState: SyncState.updated,
          );
          userLocalDbService.mockLoadUser(user: user);
          userRemoteDbService.mockUpdateUser();
          when(
            () => localDbUpdateUserMethodCall(syncState: SyncState.none),
          ).thenAnswer((_) async => user);

          await callSynchronizeUserMethod();

          verify(
            () => userRemoteDbService.updateUser(
              userId: userId,
              isDarkModeOn: user.isDarkModeOn,
              isDarkModeCompatibilityWithSystemOn:
                  user.isDarkModeCompatibilityWithSystemOn,
            ),
          ).called(1);
          verify(
            () => localDbUpdateUserMethodCall(syncState: SyncState.none),
          ).called(1);
        },
      );

      test(
        'user exists in local db, sync state is deleted, should delete user in local and remote db',
        () async {
          userLocalDbService.mockDoesUserExist(doesExist: true);
          userLocalDbService.mockLoadUserSyncState(
            syncState: SyncState.deleted,
          );
          userLocalDbService.mockLoadUser(user: user);
          userRemoteDbService.mockDeleteUser();
          userLocalDbService.mockDeleteUser();

          await callSynchronizeUserMethod();

          verify(
            () => userRemoteDbService.deleteUser(userId: userId),
          ).called(1);
          verify(
            () => userLocalDbService.deleteUser(userId: userId),
          ).called(1);
        },
      );

      test(
        'user exists in local db, sync state is none, should load user from remote db and update him in local db',
        () async {
          userLocalDbService.mockDoesUserExist(doesExist: true);
          userLocalDbService.mockLoadUserSyncState(syncState: SyncState.none);
          userRemoteDbService.mockLoadUser(user: user);
          when(
            () => localDbUpdateUserMethodCall(
              isDarkModeOn: user.isDarkModeOn,
              isDarkModeCompatibilityWithSystemOn:
                  user.isDarkModeCompatibilityWithSystemOn,
            ),
          ).thenAnswer((_) async => user);

          await callSynchronizeUserMethod();

          verify(
            () => localDbUpdateUserMethodCall(
              isDarkModeOn: user.isDarkModeOn,
              isDarkModeCompatibilityWithSystemOn:
                  user.isDarkModeCompatibilityWithSystemOn,
            ),
          ).called(1);
        },
      );
    },
  );
}
