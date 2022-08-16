import 'package:app/backend/repositories/user_repository.dart';
import 'package:app/backend/services/avatar_service.dart';
import 'package:app/backend/services/user_service.dart';
import 'package:app/models/avatar_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rxdart/rxdart.dart';

class MockUserService extends Mock implements UserService {}

class MockAvatarService extends Mock implements AvatarService {}

void main() {
  final UserService userService = MockUserService();
  final AvatarService avatarService = MockAvatarService();
  late UserRepository repository;

  setUp(() {
    repository = UserRepository(
      userService: userService,
      avatarService: avatarService,
    );
  });

  tearDown(() {
    reset(userService);
    reset(avatarService);
  });

  test('subscribe user data', () {
    BehaviorSubject<DocumentSnapshot> snapshotController = BehaviorSubject();
    when(
      () => userService.subscribeUserData(),
    ).thenAnswer((_) => snapshotController.stream);

    Stream<DocumentSnapshot>? snapshot = repository.subscribeUserData();

    expect(snapshot, snapshotController.stream);
    snapshotController.close();
  });

  test('get email', () {
    when(() => userService.getEmail()).thenReturn('example@email.com');

    String? email = repository.getEmail();

    expect(email, 'example@email.com');
  });

  test('get avatar url, success', () async {
    when(() => userService.getAvatarUrl(avatarPath: 'avatar/path'))
        .thenAnswer((_) async => 'avatar/url');

    String avatarUrl = await repository.getAvatarUrl(avatarPath: 'avatar/path');

    expect(avatarUrl, 'avatar/url');
  });

  test('get avatar url, failure', () async {
    when(() => userService.getAvatarUrl(avatarPath: 'avatar/path'))
        .thenThrow('Error...');

    try {
      await repository.getAvatarUrl(avatarPath: 'avatar/path');
    } catch (error) {
      expect(error, 'Error...');
    }
  });

  group('change avatar', () {
    setUp(() {
      when(() => avatarService.getAvatarType(StandardAvatarRed()))
          .thenReturn(AvatarType.red);
      when(() => avatarService.getImgFilePath(StandardAvatarRed()))
          .thenReturn('img/file/path');
    });

    test('success', () async {
      when(
        () => userService.changeAvatar(
          type: AvatarType.red,
          avatarImgPath: 'img/file/path',
        ),
      ).thenAnswer((_) async => '');

      await repository.changeAvatar(avatar: StandardAvatarRed());

      verify(
        () => userService.changeAvatar(
          type: AvatarType.red,
          avatarImgPath: 'img/file/path',
        ),
      ).called(1);
    });

    test('failure', () async {
      when(
        () => userService.changeAvatar(
          type: AvatarType.red,
          avatarImgPath: 'img/file/path',
        ),
      ).thenThrow('Error...');

      try {
        await repository.changeAvatar(avatar: StandardAvatarRed());
      } catch (error) {
        verify(
          () => userService.changeAvatar(
            type: AvatarType.red,
            avatarImgPath: 'img/file/path',
          ),
        ).called(1);
        expect(error, 'Error...');
      }
    });
  });

  test('change username, success', () async {
    when(() => userService.changeUsername(newUsername: 'new username'))
        .thenAnswer((_) async => '');

    await repository.changeUsername(newUsername: 'new username');

    verify(() => userService.changeUsername(newUsername: 'new username'))
        .called(1);
  });

  test('change username, failure', () async {
    when(() => userService.changeUsername(newUsername: 'new username'))
        .thenThrow('Error...');

    try {
      await repository.changeUsername(newUsername: 'new username');
    } catch (error) {
      verify(() => userService.changeUsername(newUsername: 'new username'))
          .called(1);
      expect(error, 'Error...');
    }
  });

  test('change email, success', () async {
    String newEmail = 'new.email@example.com';
    String password = 'password123';
    when(() => userService.changeEmail(newEmail: newEmail, password: password))
        .thenAnswer((_) async => '');

    await repository.changeEmail(newEmail: newEmail, password: password);

    verify(
      () => userService.changeEmail(
        newEmail: newEmail,
        password: password,
      ),
    ).called(1);
  });

  test('change email, failure', () async {
    String newEmail = 'new.email@example.com';
    String password = 'password123';
    when(() => userService.changeEmail(newEmail: newEmail, password: password))
        .thenThrow('Error...');

    try {
      await repository.changeEmail(newEmail: newEmail, password: password);
    } catch (error) {
      verify(
        () => userService.changeEmail(
          newEmail: newEmail,
          password: password,
        ),
      ).called(1);
      expect(error, 'Error...');
    }
  });

  test('change password, success', () async {
    String currentPassword = 'current password';
    String newPassword = 'new password';
    when(
      () => userService.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      ),
    ).thenAnswer((_) async => '');

    await repository.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );

    verify(
      () => userService.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      ),
    ).called(1);
  });

  test('change password, failure', () async {
    String currentPassword = 'current password';
    String newPassword = 'new password';
    when(
      () => userService.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      ),
    ).thenThrow('Error...');

    try {
      await repository.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
    } catch (error) {
      verify(
        () => userService.changePassword(
          currentPassword: currentPassword,
          newPassword: newPassword,
        ),
      ).called(1);
      expect(error, 'Error...');
    }
  });
}
