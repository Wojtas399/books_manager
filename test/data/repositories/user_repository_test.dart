import 'package:app/data/data_sources/local_db/sqlite/sqlite_sync_state.dart';
import 'package:app/data/data_sources/local_db/user_local_db_service.dart';
import 'package:app/data/data_sources/remote_db/user_remote_db_service.dart';
import 'package:app/data/models/db_user.dart';
import 'package:app/data/repositories/user_repository.dart';
import 'package:app/domain/entities/user.dart';
import 'package:app/models/device.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockUserLocalDbService extends Mock implements UserLocalDbService {}

class MockUserRemoteDbService extends Mock implements UserRemoteDbService {}

class MockDevice extends Mock implements Device {}

void main() {
  final userLocalDbService = MockUserLocalDbService();
  final userRemoteDbService = MockUserRemoteDbService();
  final device = MockDevice();
  late UserRepository repository;

  UserRepository createRepository({
    List<User> users = const [],
  }) {
    return UserRepository(
      userLocalDbService: userLocalDbService,
      userRemoteDbService: userRemoteDbService,
      device: device,
      users: users,
    );
  }

  void mockHasDeviceInternetConnection({required bool hasInternetConnection}) {
    when(
      () => device.hasInternetConnection(),
    ).thenAnswer((_) async => hasInternetConnection);
  }

  setUpAll(() {
    registerFallbackValue(SyncState.none);
  });

  setUp(() {
    repository = createRepository();
  });

  tearDown(() {
    reset(userLocalDbService);
    reset(userRemoteDbService);
    reset(device);
  });

  test(
    'get user, should return stream which contains matching user',
    () async {
      const String userId = 'u1';
      final List<User> users = [
        createUser(id: 'u0'),
        createUser(id: userId),
        createUser(id: 'u2'),
      ];
      final User expectedUser = users[1];
      repository = createRepository(users: users);

      final Stream<User?> user$ = repository.getUser(userId: userId);

      expect(await user$.first, expectedUser);
    },
  );

  test(
    'load user, should load user from local db and assign him to list',
    () async {
      const String userId = 'u1';
      final DbUser dbUser = createDbUser(id: userId);
      final User expectedUser = createUser(
        id: dbUser.id,
        isDarkModeOn: dbUser.isDarkModeOn,
        isDarkModeCompatibilityWithSystemOn:
            dbUser.isDarkModeCompatibilityWithSystemOn,
      );
      when(
        () => userLocalDbService.loadUser(userId: userId),
      ).thenAnswer((_) async => dbUser);

      await repository.loadUser(userId: userId);
      final Stream<User?> user$ = repository.getUser(userId: userId);

      expect(await user$.first, expectedUser);
    },
  );

  group(
    'add user',
    () {
      final User user = createUser(id: 'u1');
      final DbUser dbUser = createDbUser(
        id: user.id,
        isDarkModeOn: user.isDarkModeOn,
        isDarkModeCompatibilityWithSystemOn:
            user.isDarkModeCompatibilityWithSystemOn,
      );

      Future<void> localDbServiceAddMethodCall({SyncState? syncState}) =>
          userLocalDbService.addUser(
            dbUser: dbUser,
            syncState: syncState ?? any(named: 'syncState'),
          );

      Future<void> remoteDbServiceAddMethodCall() =>
          userRemoteDbService.addUser(dbUser: dbUser);

      setUp(() {
        when(
          () => localDbServiceAddMethodCall(),
        ).thenAnswer((_) async => '');
        when(
          () => remoteDbServiceAddMethodCall(),
        ).thenAnswer((_) async => '');
      });

      test(
        'device has internet connection, should call methods responsible for adding user to remote and local databases and should add new user to list',
        () async {
          mockHasDeviceInternetConnection(hasInternetConnection: true);

          await repository.addUser(user: user);
          final Stream<User?> user$ = repository.getUser(userId: user.id);

          verify(
            () => localDbServiceAddMethodCall(syncState: SyncState.none),
          ).called(1);
          verify(
            () => remoteDbServiceAddMethodCall(),
          ).called(1);
          expect(await user$.first, user);
        },
      );

      test(
        'device has not internet connection, should only call method responsible for adding user to local db with sync state set as added and should add new user to list',
        () async {
          mockHasDeviceInternetConnection(hasInternetConnection: false);

          await repository.addUser(user: user);
          final Stream<User?> user$ = repository.getUser(userId: user.id);

          verify(
            () => localDbServiceAddMethodCall(syncState: SyncState.added),
          ).called(1);
          verifyNever(
            () => remoteDbServiceAddMethodCall(),
          );
          expect(await user$.first, user);
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
      final DbUser updatedDbUser = createDbUser(
        id: userId,
        isDarkModeOn: isDarkModeOn,
        isDarkModeCompatibilityWithSystemOn:
            isDarkModeCompatibilityWithSystemOn,
      );
      final User originalUser = createUser(
        id: userId,
        isDarkModeOn: true,
        isDarkModeCompatibilityWithSystemOn: false,
      );
      final User updatedUser = createUser(
        id: userId,
        isDarkModeOn: isDarkModeOn,
        isDarkModeCompatibilityWithSystemOn:
            isDarkModeCompatibilityWithSystemOn,
      );

      Future<void> callRepositoryUpdateMethod() => repository.updateUser(
            userId: userId,
            isDarkModeOn: isDarkModeOn,
            isDarkModeCompatibilityWithSystemOn:
                isDarkModeCompatibilityWithSystemOn,
          );

      Future<DbUser> localDbServiceUpdateMethodCall({SyncState? syncState}) =>
          userLocalDbService.updateUser(
            userId: userId,
            isDarkModeOn: isDarkModeOn,
            isDarkModeCompatibilityWithSystemOn:
                isDarkModeCompatibilityWithSystemOn,
            syncState: syncState ?? any(named: 'syncState'),
          );

      Future<void> remoteDbServiceUpdateMethodCall() =>
          userRemoteDbService.updateUser(
            userId: userId,
            isDarkModeOn: isDarkModeOn,
            isDarkModeCompatibilityWithSystemOn:
                isDarkModeCompatibilityWithSystemOn,
          );

      setUp(() {
        repository = createRepository(users: [originalUser]);
        when(
          () => localDbServiceUpdateMethodCall(),
        ).thenAnswer((_) async => updatedDbUser);
        when(
          () => remoteDbServiceUpdateMethodCall(),
        ).thenAnswer((_) async => '');
      });

      test(
        'device has internet connection, should call methods responsible for updating user in remote and local databases and should update user in list',
        () async {
          mockHasDeviceInternetConnection(hasInternetConnection: true);

          await callRepositoryUpdateMethod();
          final Stream<User?> user$ = repository.getUser(userId: userId);

          verify(
            () => localDbServiceUpdateMethodCall(syncState: SyncState.none),
          ).called(1);
          verify(
            () => remoteDbServiceUpdateMethodCall(),
          ).called(1);
          expect(await user$.first, updatedUser);
        },
      );

      test(
        'device has not internet connection, should only call method responsible for updating user in local db with sync state set as updated and should update user in list',
        () async {
          mockHasDeviceInternetConnection(hasInternetConnection: false);

          await callRepositoryUpdateMethod();
          final Stream<User?> user$ = repository.getUser(userId: userId);

          verify(
            () => localDbServiceUpdateMethodCall(syncState: SyncState.updated),
          ).called(1);
          verifyNever(
            () => remoteDbServiceUpdateMethodCall(),
          );
          expect(await user$.first, updatedUser);
        },
      );
    },
  );

  group(
    'delete user',
    () {
      const String userId = 'u1';

      Future<void> localDbServiceDeleteMethodCall() =>
          userLocalDbService.deleteUser(userId: userId);

      Future<void> remoteDbServiceDeleteMethodCall() =>
          userRemoteDbService.deleteUser(userId: userId);

      setUp(() {
        repository = createRepository(
          users: [createUser(id: userId)],
        );
        when(
          () => localDbServiceDeleteMethodCall(),
        ).thenAnswer((_) async => '');
        when(
          () => remoteDbServiceDeleteMethodCall(),
        ).thenAnswer((_) async => '');
      });

      test(
        'device has internet connection, should call methods responsible for deleting user from local and remote databases and should delete user from list',
        () async {
          mockHasDeviceInternetConnection(hasInternetConnection: true);

          await repository.deleteUser(userId: userId);
          final Stream<User?> user$ = repository.getUser(userId: userId);

          verify(
            () => localDbServiceDeleteMethodCall(),
          ).called(1);
          verify(
            () => remoteDbServiceDeleteMethodCall(),
          ).called(1);
          expect(await user$.first, null);
        },
      );

      test(
        'device has not internet connection, should only call method responsible for updating user in local db with sync state set as deleted and should delete user from list',
        () async {
          mockHasDeviceInternetConnection(hasInternetConnection: false);
          when(
            () => userLocalDbService.updateUser(
              userId: userId,
              syncState: SyncState.deleted,
            ),
          ).thenAnswer((_) async => createDbUser());

          await repository.deleteUser(userId: userId);
          final Stream<User?> user$ = repository.getUser(userId: userId);

          verifyNever(
            () => localDbServiceDeleteMethodCall(),
          );
          verifyNever(
            () => remoteDbServiceDeleteMethodCall(),
          );
          verify(
            () => userLocalDbService.updateUser(
              userId: userId,
              syncState: SyncState.deleted,
            ),
          ).called(1);
          expect(await user$.first, null);
        },
      );
    },
  );
}
