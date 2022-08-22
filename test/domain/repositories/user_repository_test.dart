import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:app/database/firebase/services/fire_avatar_service.dart';
import 'package:app/database/firebase/services/fire_user_service.dart';
import 'package:app/database/firebase/fire_extensions.dart';
import 'package:app/domain/repositories/user_repository.dart';
import 'package:app/models/avatar.dart';

class MockFireUserService extends Mock implements FireUserService {}

class MockFireAvatarService extends Mock implements FireAvatarService {}

void main() {
  final fireUserService = MockFireUserService();
  final fireAvatarService = MockFireAvatarService();
  late UserRepository repository;

  setUp(() {
    repository = UserRepository(
      fireUserService: fireUserService,
      fireAvatarService: fireAvatarService,
    );
  });

  tearDown(() {
    reset(fireUserService);
    reset(fireAvatarService);
  });

  test(
    'set user data, should call methods responsible for uploading avatar and for setting user data',
    () async {
      const String username = 'username';
      final File imageFile = File('path/to/file');
      final Avatar avatar = FileAvatar(file: imageFile);
      const String pathToAvatarInDb = 'path/to/avatar/in/db';
      when(
        () => fireAvatarService.uploadLoggedUserAvatar(imageFile: imageFile),
      ).thenAnswer((_) async => pathToAvatarInDb);
      when(
        () => fireUserService.setUserData(
          username: username,
          pathToAvatarInStorage: pathToAvatarInDb,
        ),
      ).thenAnswer((_) async => '');

      await repository.setUserData(username: username, avatar: avatar);

      verify(
        () => fireAvatarService.uploadLoggedUserAvatar(imageFile: imageFile),
      ).called(1);
      verify(
        () => fireUserService.setUserData(
          username: username,
          pathToAvatarInStorage: pathToAvatarInDb,
        ),
      ).called(1);
    },
  );

  test(
    'set user data, should only call method responsible for setting user data in case of providing basic avatar',
    () async {
      const String username = 'username';
      const BasicAvatarType avatarType = BasicAvatarType.green;
      const Avatar avatar = BasicAvatar(type: avatarType);
      final String pathToAvatarInDb = avatarType.toFirebaseString();
      when(
        () => fireUserService.setUserData(
          username: username,
          pathToAvatarInStorage: pathToAvatarInDb,
        ),
      ).thenAnswer((_) async => '');

      await repository.setUserData(username: username, avatar: avatar);

      verify(
        () => fireUserService.setUserData(
          username: username,
          pathToAvatarInStorage: pathToAvatarInDb,
        ),
      ).called(1);
    },
  );
}
