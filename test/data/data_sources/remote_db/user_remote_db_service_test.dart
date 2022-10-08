import 'package:app/data/data_sources/remote_db/firebase/models/firebase_user.dart';
import 'package:app/data/data_sources/remote_db/user_remote_db_service.dart';
import 'package:app/domain/entities/user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks/firebase/mock_firebase_firestore_user_service.dart';

void main() {
  final firebaseFirestoreUserService = MockFirebaseFirestoreUserService();
  late UserRemoteDbService service;

  setUp(() {
    service = UserRemoteDbService(
      firebaseFirestoreUserService: firebaseFirestoreUserService,
    );
  });

  tearDown(() {
    reset(firebaseFirestoreUserService);
  });

  test(
    'load user, should load user from firebase firestore',
    () async {
      const String userId = 'u1';
      final FirebaseUser firebaseUser = createFirebaseUser(id: userId);
      final User expectedUser = createUser(
        id: firebaseUser.id,
        isDarkModeOn: firebaseUser.isDarkModeOn,
        isDarkModeCompatibilityWithSystemOn:
            firebaseUser.isDarkModeCompatibilityWithSystemOn,
      );
      firebaseFirestoreUserService.mockLoadUser(firebaseUser: firebaseUser);

      final User user = await service.loadUser(userId: userId);

      expect(user, expectedUser);
    },
  );

  test(
    'add book, should call method responsible for adding user to firebase firestore',
    () async {
      final User userToAdd = createUser(id: 'u1');
      final FirebaseUser firebaseUserToAdd = createFirebaseUser(
        id: userToAdd.id,
        isDarkModeOn: userToAdd.isDarkModeOn,
        isDarkModeCompatibilityWithSystemOn:
            userToAdd.isDarkModeCompatibilityWithSystemOn,
      );
      firebaseFirestoreUserService.mockAddUser();

      await service.addUser(user: userToAdd);

      verify(
        () => firebaseFirestoreUserService.addUser(
          firebaseUser: firebaseUserToAdd,
        ),
      ).called(1);
    },
  );

  test(
    'update user, should call method responsible for updating user in firebase firestore',
    () async {
      const String userId = 'u1';
      const bool isDarkModeOn = true;
      const bool isDarkModeCompatibilityWithSystemOn = false;
      firebaseFirestoreUserService.mockUpdateUser();

      await service.updateUser(
        userId: userId,
        isDarkModeOn: isDarkModeOn,
        isDarkModeCompatibilityWithSystemOn:
            isDarkModeCompatibilityWithSystemOn,
      );

      verify(
        () => firebaseFirestoreUserService.updateUser(
          userId: userId,
          isDarkModeOn: isDarkModeOn,
          isDarkModeCompatibilityWithSystemOn:
              isDarkModeCompatibilityWithSystemOn,
        ),
      ).called(1);
    },
  );

  test(
    'delete user, should call method responsible for deleting user from firebase firestore',
    () async {
      const String userId = 'u1';
      firebaseFirestoreUserService.mockDeleteUser();

      await service.deleteUser(userId: userId);

      verify(
        () => firebaseFirestoreUserService.deleteUser(userId: userId),
      ).called(1);
    },
  );
}
