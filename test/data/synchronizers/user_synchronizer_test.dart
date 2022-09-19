import 'package:app/data/data_sources/local_db/sqlite/sqlite_sync_state.dart';
import 'package:app/data/data_sources/local_db/user_local_db_service.dart';
import 'package:app/data/data_sources/remote_db/user_remote_db_service.dart';
import 'package:app/data/models/db_user.dart';
import 'package:app/data/synchronizers/user_synchronizer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockUserLocalDbService extends Mock implements UserLocalDbService {}

class MockUserRemoteDbService extends Mock implements UserRemoteDbService {}

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
      final DbUser dbUser = createDbUser(id: userId);

      Future<bool> localDbDoesUserExistMethodCall() {
        return userLocalDbService.doesUserExist(userId: userId);
      }

      Future<DbUser> localDbLoadUserMethodCall() {
        return userLocalDbService.loadUser(userId: userId);
      }

      Future<SyncState> localDbLoadUserSyncStateMethodCall() {
        return userLocalDbService.loadUserSyncState(userId: userId);
      }

      Future<void> localDbAddUserMethodCall() {
        return userLocalDbService.addUser(dbUser: dbUser);
      }

      Future<DbUser> localDbUpdateUserMethodCall({
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

      Future<void> localDbDeleteUserMethodCall() {
        return userLocalDbService.deleteUser(userId: userId);
      }

      Future<DbUser> remoteDbLoadUserMethodCall() {
        return userRemoteDbService.loadUser(userId: userId);
      }

      Future<void> remoteDbAddUserMethodCall() {
        return userRemoteDbService.addUser(dbUser: dbUser);
      }

      Future<void> remoteDbUpdateUserMethodCall() {
        return userRemoteDbService.updateUser(
          userId: userId,
          isDarkModeOn: dbUser.isDarkModeOn,
          isDarkModeCompatibilityWithSystemOn:
              dbUser.isDarkModeCompatibilityWithSystemOn,
        );
      }

      Future<void> remoteDbDeleteUserMethodCall() {
        return userRemoteDbService.deleteUser(userId: userId);
      }

      Future<void> callSynchronizeUserMethod() async {
        await synchronizer.synchronizeUser(userId: userId);
      }

      test(
        'user does not exist in local db, should load user from remote db and add him to local db',
        () async {
          when(localDbDoesUserExistMethodCall).thenAnswer((_) async => false);
          when(remoteDbLoadUserMethodCall).thenAnswer((_) async => dbUser);
          when(localDbAddUserMethodCall).thenAnswer((_) async => '');

          await callSynchronizeUserMethod();

          verify(localDbAddUserMethodCall).called(1);
        },
      );

      test(
        'user exists in local db, sync state is added, should load user from local db, add him to remote db and update sync state in local db to none',
        () async {
          when(localDbDoesUserExistMethodCall).thenAnswer((_) async => true);
          when(
            localDbLoadUserSyncStateMethodCall,
          ).thenAnswer((_) async => SyncState.added);
          when(localDbLoadUserMethodCall).thenAnswer((_) async => dbUser);
          when(remoteDbAddUserMethodCall).thenAnswer((_) async => '');
          when(
            () => localDbUpdateUserMethodCall(syncState: SyncState.none),
          ).thenAnswer((_) async => dbUser);

          await callSynchronizeUserMethod();

          verify(remoteDbAddUserMethodCall).called(1);
          verify(
            () => localDbUpdateUserMethodCall(syncState: SyncState.none),
          ).called(1);
        },
      );

      test(
        'user exists in local db, sync state is updated, should load user from local db, update him in remote db and update sync state in local db to none',
        () async {
          when(localDbDoesUserExistMethodCall).thenAnswer((_) async => true);
          when(
            localDbLoadUserSyncStateMethodCall,
          ).thenAnswer((_) async => SyncState.updated);
          when(localDbLoadUserMethodCall).thenAnswer((_) async => dbUser);
          when(remoteDbUpdateUserMethodCall).thenAnswer((_) async => '');
          when(
            () => localDbUpdateUserMethodCall(syncState: SyncState.none),
          ).thenAnswer((_) async => dbUser);

          await callSynchronizeUserMethod();

          verify(remoteDbUpdateUserMethodCall).called(1);
          verify(
            () => localDbUpdateUserMethodCall(syncState: SyncState.none),
          ).called(1);
        },
      );

      test(
        'user exists in local db, sync state is deleted, should delete user in local and remote db',
        () async {
          when(localDbDoesUserExistMethodCall).thenAnswer((_) async => true);
          when(
            localDbLoadUserSyncStateMethodCall,
          ).thenAnswer((_) async => SyncState.deleted);
          when(localDbLoadUserMethodCall).thenAnswer((_) async => dbUser);
          when(remoteDbDeleteUserMethodCall).thenAnswer((_) async => '');
          when(localDbDeleteUserMethodCall).thenAnswer((_) async => '');

          await callSynchronizeUserMethod();

          verify(remoteDbDeleteUserMethodCall).called(1);
          verify(localDbDeleteUserMethodCall).called(1);
        },
      );

      test(
        'user exists in local db, sync state is none, should load user from remote db and update him in local db',
        () async {
          when(localDbDoesUserExistMethodCall).thenAnswer((_) async => true);
          when(
            localDbLoadUserSyncStateMethodCall,
          ).thenAnswer((_) async => SyncState.none);
          when(remoteDbLoadUserMethodCall).thenAnswer((_) async => dbUser);
          when(
            () => localDbUpdateUserMethodCall(
              isDarkModeOn: dbUser.isDarkModeOn,
              isDarkModeCompatibilityWithSystemOn:
                  dbUser.isDarkModeCompatibilityWithSystemOn,
            ),
          ).thenAnswer((_) async => dbUser);

          await callSynchronizeUserMethod();

          verify(
            () => localDbUpdateUserMethodCall(
              isDarkModeOn: dbUser.isDarkModeOn,
              isDarkModeCompatibilityWithSystemOn:
                  dbUser.isDarkModeCompatibilityWithSystemOn,
            ),
          ).called(1);
        },
      );
    },
  );
}
