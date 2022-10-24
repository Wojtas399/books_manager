import 'package:app/data/repositories/user_repository.dart';
import 'package:app/domain/entities/user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/data/data_sources/mock_users_data_source.dart';

void main() {
  final usersDataSource = MockUsersDataSource();
  late UserRepository repository;

  UserRepository createRepository({
    List<User> users = const [],
  }) {
    return UserRepository(
      usersDataSource: usersDataSource,
      users: users,
    );
  }

  setUp(() {
    repository = createRepository();
  });

  tearDown(() {
    reset(usersDataSource);
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
    'load user, should set user listener and should assign loaded user to list',
    () async {
      const String userId = 'u1';
      final User expectedUser = createUser(id: userId);
      usersDataSource.mockGetUserStream(user: expectedUser);

      await repository.loadUser(userId: userId);
      final Stream<User?> user$ = repository.getUser(userId: userId);

      expect(await user$.first, expectedUser);
    },
  );

  test(
    'add user, should call method responsible for adding user and should add user to list',
    () async {
      const String userId = 'u1';
      final User userToAdd = createUser(id: userId);
      usersDataSource.mockAddUser();

      await repository.addUser(user: userToAdd);
      final Stream<User?> user$ = repository.getUser(userId: userId);

      verify(
        () => usersDataSource.addUser(user: userToAdd),
      ).called(1);
      expect(await user$.first, userToAdd);
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

      Future<void> methodCall() async {
        await repository.updateUserThemeSettings(
          userId: userId,
          isDarkModeOn: isDarkModeOn,
          isDarkModeCompatibilityWithSystemOn:
              isDarkModeCompatibilityWithSystemOn,
        );
      }

      setUp(() {
        repository = createRepository(users: [originalUser]);
      });

      tearDown(() {
        verify(
          () => usersDataSource.updateUser(
            userId: userId,
            isDarkModeOn: isDarkModeOn,
            isDarkModeCompatibilityWithSystemOn:
                isDarkModeCompatibilityWithSystemOn,
          ),
        ).called(1);
      });

      test(
        'should update user in list and then should call method responsible for updating user',
        () async {
          usersDataSource.mockUpdateUser(updatedUser: updatedUser);

          await methodCall();
          final Stream<User?> user$ = repository.getUser(userId: userId);

          expect(await user$.first, updatedUser);
        },
      );

      test(
        'should set previous user data if one of called methods throws error',
        () async {
          usersDataSource.mockUpdateUser(
            updatedUser: updatedUser,
            throwable: 'Error...',
          );

          await methodCall();
          final Stream<User?> user$ = repository.getUser(userId: userId);

          expect(await user$.first, originalUser);
        },
      );
    },
  );

  test(
    'delete user, should call method responsible for deleting user and should delete user from list',
    () async {
      const String userId = 'u1';
      usersDataSource.mockDeleteUser();
      repository = createRepository(
        users: [createUser(id: userId)],
      );

      await repository.deleteUser(userId: userId);
      final Stream<User?> user$ = repository.getUser(userId: userId);

      verify(
        () => usersDataSource.deleteUser(userId: userId),
      ).called(1);
      expect(await user$.first, null);
    },
  );
}
