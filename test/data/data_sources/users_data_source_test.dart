import 'package:app/data/data_sources/firebase/entities/firebase_user.dart';
import 'package:app/data/data_sources/users_data_source.dart';
import 'package:app/domain/entities/user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/data/data_sources/firebase/mock_firebase_database_users_service.dart';

void main() {
  final firebaseDatabaseUsersService = MockFirebaseDatabaseUsersService();
  late UsersDataSource dataSource;

  setUp(() {
    dataSource = UsersDataSource(
      firebaseDatabaseUsersService: firebaseDatabaseUsersService,
    );
  });

  tearDown(() {
    reset(firebaseDatabaseUsersService);
  });

  test(
    'get user stream, should return stream which contains firebase user mapped to User model',
    () async {
      const String userId = 'u1';
      final FirebaseUser firebaseUser = createFirebaseUser(
        id: userId,
        isDarkModeOn: true,
        isDarkModeCompatibilityWithSystemOn: false,
      );
      final User expectedUser = createUser(
        id: firebaseUser.id,
        isDarkModeOn: firebaseUser.isDarkModeOn,
        isDarkModeCompatibilityWithSystemOn:
            firebaseUser.isDarkModeCompatibilityWithSystemOn,
      );
      firebaseDatabaseUsersService.mockGetUserStream(
        firebaseUser: firebaseUser,
      );

      final Stream<User?> user$ = dataSource.getUserStream(userId: userId);

      expect(await user$.first, expectedUser);
    },
  );

  test(
    'add user, should call method responsible for adding user',
    () async {
      final User user = createUser(id: 'u1');
      final FirebaseUser firebaseUser = createFirebaseUser(
        id: user.id,
        isDarkModeOn: user.isDarkModeOn,
        isDarkModeCompatibilityWithSystemOn:
            user.isDarkModeCompatibilityWithSystemOn,
      );
      firebaseDatabaseUsersService.mockAddUser();

      await dataSource.addUser(user: user);

      verify(
        () => firebaseDatabaseUsersService.addUser(
          firebaseUser: firebaseUser,
        ),
      ).called(1);
    },
  );

  test(
    'update user, should call method responsible for updating user and should return updated user',
    () async {
      const String userId = 'u1';
      const bool isDarkModeOn = true;
      const bool isDarkModeCompatibilityWithSystemOn = false;
      final FirebaseUser updatedFirebaseUser = createFirebaseUser(
        id: userId,
        isDarkModeOn: isDarkModeOn,
        isDarkModeCompatibilityWithSystemOn:
            isDarkModeCompatibilityWithSystemOn,
      );
      final User expectedUpdatedUser = createUser(
        id: updatedFirebaseUser.id,
        isDarkModeOn: updatedFirebaseUser.isDarkModeOn,
        isDarkModeCompatibilityWithSystemOn:
            updatedFirebaseUser.isDarkModeCompatibilityWithSystemOn,
      );
      firebaseDatabaseUsersService.mockUpdateUser(
        updatedFirebaseUser: updatedFirebaseUser,
      );

      final User updatedUser = await dataSource.updateUser(
        userId: userId,
        isDarkModeOn: isDarkModeOn,
        isDarkModeCompatibilityWithSystemOn:
            isDarkModeCompatibilityWithSystemOn,
      );

      verify(
        () => firebaseDatabaseUsersService.updateUser(
          userId: userId,
          isDarkModeOn: isDarkModeOn,
          isDarkModeCompatibilityWithSystemOn:
              isDarkModeCompatibilityWithSystemOn,
        ),
      ).called(1);
      expect(updatedUser, expectedUpdatedUser);
    },
  );

  test(
    'delete user, should call method responsible for deleting user',
    () async {
      const String userId = 'u1';
      firebaseDatabaseUsersService.mockDeleteUser();

      await dataSource.deleteUser(userId: userId);

      verify(
        () => firebaseDatabaseUsersService.deleteUser(userId: userId),
      ).called(1);
    },
  );
}
