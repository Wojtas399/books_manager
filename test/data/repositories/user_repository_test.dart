import 'package:app/data/data_sources/local_db/sqlite/sqlite_sync_state.dart';
import 'package:app/data/repositories/user_repository.dart';
import 'package:app/domain/entities/user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/db_services/mock_user_local_db_service.dart';
import '../../mocks/db_services/mock_user_remote_db_service.dart';
import '../../mocks/mock_device.dart';
import '../../mocks/synchronizers/mock_user_synchronizer.dart';

void main() {
  final userSynchronizer = MockUserSynchronizer();
  final userLocalDbService = MockUserLocalDbService();
  final userRemoteDbService = MockUserRemoteDbService();
  final device = MockDevice();
  late UserRepository repository;

  UserRepository createRepository({
    List<User> users = const [],
  }) {
    return UserRepository(
      userSynchronizer: userSynchronizer,
      userLocalDbService: userLocalDbService,
      userRemoteDbService: userRemoteDbService,
      device: device,
      users: users,
    );
  }

  setUp(() {
    repository = createRepository();
  });

  tearDown(() {
    reset(userSynchronizer);
    reset(userLocalDbService);
    reset(userRemoteDbService);
    reset(device);
  });

  group(
    'initialize user',
    () {
      const String userId = 'u1';

      setUp(() {
        userSynchronizer.mockSynchronizeUser();
      });

      test(
        'device has internet connection, should call method from user synchronizer responsible for synchronizing user',
        () async {
          device.mockHasDeviceInternetConnection(value: true);

          await repository.initializeUser(userId: userId);

          verify(
            () => userSynchronizer.synchronizeUser(userId: userId),
          ).called(1);
        },
      );

      test(
        'device has not internet connection, should not do anything',
        () async {
          device.mockHasDeviceInternetConnection(value: false);

          await repository.initializeUser(userId: userId);

          verifyNever(
            () => userSynchronizer.synchronizeUser(userId: userId),
          );
        },
      );
    },
  );

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
      final User expectedUser = createUser(id: userId);
      userLocalDbService.mockLoadUser(user: expectedUser);

      await repository.loadUser(userId: userId);
      final Stream<User?> user$ = repository.getUser(userId: userId);

      expect(await user$.first, expectedUser);
    },
  );

  group(
    'add user',
    () {
      final User user = createUser(id: 'u1');

      setUp(() {
        userLocalDbService.mockAddUser();
        userRemoteDbService.mockAddUser();
      });

      test(
        'device has internet connection, should call methods responsible for adding user to remote and local databases and should add new user to list',
        () async {
          device.mockHasDeviceInternetConnection(value: true);

          await repository.addUser(user: user);
          final Stream<User?> user$ = repository.getUser(userId: user.id);

          verify(
            () => userLocalDbService.addUser(
              user: user,
              syncState: SyncState.none,
            ),
          ).called(1);
          verify(
            () => userRemoteDbService.addUser(user: user),
          ).called(1);
          expect(await user$.first, user);
        },
      );

      test(
        'device has not internet connection, should only call method responsible for adding user to local db with sync state set as added and should add new user to list',
        () async {
          device.mockHasDeviceInternetConnection(value: false);

          await repository.addUser(user: user);
          final Stream<User?> user$ = repository.getUser(userId: user.id);

          verify(
            () => userLocalDbService.addUser(
              user: user,
              syncState: SyncState.added,
            ),
          ).called(1);
          verifyNever(
            () => userRemoteDbService.addUser(user: user),
          );
          expect(await user$.first, user);
        },
      );
    },
  );

  group(
    'update user theme settings',
    () {
      const String userId = 'u1';
      const bool isDarkModeOn = false;
      const bool isDarkModeCompatibilityWithSystemOn = true;
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

      setUp(() {
        repository = createRepository(users: [originalUser]);
        userLocalDbService.mockUpdateUser(updatedUser: updatedUser);
        userRemoteDbService.mockUpdateUser();
      });

      test(
        'device has internet connection, should update user in list and then should call methods responsible for updating user in remote and local databases',
        () async {
          device.mockHasDeviceInternetConnection(value: true);

          await repository.updateUserThemeSettings(
            userId: userId,
            isDarkModeOn: isDarkModeOn,
            isDarkModeCompatibilityWithSystemOn:
                isDarkModeCompatibilityWithSystemOn,
          );
          final Stream<User?> user$ = repository.getUser(userId: userId);

          verify(
            () => userLocalDbService.updateUser(
              userId: userId,
              isDarkModeOn: isDarkModeOn,
              isDarkModeCompatibilityWithSystemOn:
                  isDarkModeCompatibilityWithSystemOn,
              syncState: SyncState.none,
            ),
          ).called(1);
          verify(
            () => userRemoteDbService.updateUser(
              userId: userId,
              isDarkModeOn: isDarkModeOn,
              isDarkModeCompatibilityWithSystemOn:
                  isDarkModeCompatibilityWithSystemOn,
            ),
          ).called(1);
          expect(await user$.first, updatedUser);
        },
      );

      test(
        'device has not internet connection, should update user in list and then should call method responsible for updating user in local db with sync state set as updated',
        () async {
          device.mockHasDeviceInternetConnection(value: false);

          await repository.updateUserThemeSettings(
            userId: userId,
            isDarkModeOn: isDarkModeOn,
            isDarkModeCompatibilityWithSystemOn:
                isDarkModeCompatibilityWithSystemOn,
          );
          final Stream<User?> user$ = repository.getUser(userId: userId);

          verify(
            () => userLocalDbService.updateUser(
              userId: userId,
              isDarkModeOn: isDarkModeOn,
              isDarkModeCompatibilityWithSystemOn:
                  isDarkModeCompatibilityWithSystemOn,
              syncState: SyncState.updated,
            ),
          ).called(1);
          verifyNever(
            () => userRemoteDbService.updateUser(
              userId: userId,
              isDarkModeOn: isDarkModeOn,
              isDarkModeCompatibilityWithSystemOn:
                  isDarkModeCompatibilityWithSystemOn,
            ),
          );
          expect(await user$.first, updatedUser);
        },
      );

      test(
        'should set previous user data if one of called methods throws error',
        () async {
          device.mockHasDeviceInternetConnection(value: true);
          userRemoteDbService.mockUpdateUser(throwable: 'Error...');

          await repository.updateUserThemeSettings(
            userId: userId,
            isDarkModeOn: isDarkModeOn,
            isDarkModeCompatibilityWithSystemOn:
                isDarkModeCompatibilityWithSystemOn,
          );
          final Stream<User?> user$ = repository.getUser(userId: userId);

          expect(await user$.first, originalUser);
        },
      );
    },
  );

  group(
    'delete user',
    () {
      const String userId = 'u1';

      setUp(() {
        repository = createRepository(
          users: [createUser(id: userId)],
        );
        userLocalDbService.mockDeleteUser();
        userRemoteDbService.mockDeleteUser();
      });

      test(
        'device has internet connection, should call methods responsible for deleting user from local and remote databases and should delete user from list',
        () async {
          device.mockHasDeviceInternetConnection(value: true);

          await repository.deleteUser(userId: userId);
          final Stream<User?> user$ = repository.getUser(userId: userId);

          verify(
            () => userLocalDbService.deleteUser(userId: userId),
          ).called(1);
          verify(
            () => userRemoteDbService.deleteUser(userId: userId),
          ).called(1);
          expect(await user$.first, null);
        },
      );

      test(
        'device has not internet connection, should only call method responsible for updating user in local db with sync state set as deleted and should delete user from list',
        () async {
          device.mockHasDeviceInternetConnection(value: false);
          userLocalDbService.mockUpdateUser(updatedUser: createUser());

          await repository.deleteUser(userId: userId);
          final Stream<User?> user$ = repository.getUser(userId: userId);

          verifyNever(
            () => userLocalDbService.deleteUser(userId: userId),
          );
          verifyNever(
            () => userRemoteDbService.deleteUser(userId: userId),
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
