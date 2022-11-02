import 'package:app/data/repositories/user_repository.dart';
import 'package:app/domain/entities/user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/data_sources/mock_user_data_source.dart';

void main() {
  final userDataSource = MockUserDataSource();
  late UserRepository repository;
  const String userId = 'u1';

  UserRepository createRepository() {
    return UserRepository(userDataSource: userDataSource);
  }

  setUp(() {
    repository = createRepository();
  });

  tearDown(() {
    reset(userDataSource);
  });

  test(
    'get user, should return stream which contains matching user',
    () async {
      final List<User> users = [
        createUser(id: 'u0'),
        createUser(id: userId),
        createUser(id: 'u2'),
      ];
      final User expectedUser = users[1];
      userDataSource.mockGetUser(user: expectedUser);

      final Stream<User?> user$ = repository.getUser(userId: userId);

      expect(await user$.first, expectedUser);
    },
  );

  test(
    'add user, should call method responsible for adding user',
    () async {
      final User userToAdd = createUser(id: userId);
      userDataSource.mockAddUser();

      await repository.addUser(user: userToAdd);

      verify(
        () => userDataSource.addUser(user: userToAdd),
      ).called(1);
    },
  );

  test(
    'update user, should call method responsible for updating user',
    () async {
      const bool isDarkModeOn = false;
      const bool isDarkModeCompatibilityWithSystemOn = true;
      userDataSource.mockUpdateUser();

      await repository.updateUser(
        userId: userId,
        isDarkModeOn: isDarkModeOn,
        isDarkModeCompatibilityWithSystemOn:
            isDarkModeCompatibilityWithSystemOn,
      );

      verify(
        () => userDataSource.updateUser(
          userId: userId,
          isDarkModeOn: isDarkModeOn,
          isDarkModeCompatibilityWithSystemOn:
              isDarkModeCompatibilityWithSystemOn,
        ),
      ).called(1);
    },
  );

  test(
    'delete user, should call method responsible for deleting user',
    () async {
      userDataSource.mockDeleteUser();

      await repository.deleteUser(userId: userId);

      verify(
        () => userDataSource.deleteUser(userId: userId),
      ).called(1);
    },
  );
}
