import 'package:app/backend/repositories/auth_repository.dart';
import 'package:app/backend/services/auth_service.dart';
import 'package:app/backend/services/avatar_service.dart';
import 'package:app/interfaces/avatar_interface.dart';
import 'package:app/models/avatar_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthService extends Mock implements AuthService {}

class MockAvatarService extends Mock implements AvatarService {}

void main() {
  final AuthService authService = MockAuthService();
  final AvatarService avatarService = MockAvatarService();
  late AuthRepository repository;
  String username = 'Jack Novicky';
  String email = 'jack@example.com';
  String password = 'jackish321';
  AvatarInterface avatar = StandardAvatarRed();

  setUp(() {
    repository = AuthRepository(
      authService: authService,
      avatarService: avatarService,
    );
  });

  tearDown(() {
    reset(authService);
    reset(avatarService);
  });

  test('sign in, success', () async {
    when(
      () => authService.signIn(email: email, password: password),
    ).thenAnswer((_) async => '');

    await repository.signIn(email: email, password: password);

    verify(
      () => authService.signIn(email: email, password: password),
    ).called(1);
  });

  test('sign in, failure', () async {
    when(
      () => authService.signIn(email: email, password: password),
    ).thenThrow('Error...');

    try {
      await repository.signIn(email: email, password: password);
    } catch (error) {
      verify(
        () => authService.signIn(email: email, password: password),
      ).called(1);
      expect(error, 'Error...');
    }
  });

  test('sign up, success', () async {
    when(() => avatarService.getAvatarType(avatar)).thenReturn(AvatarType.red);
    when(
      () => authService.signUp(
        username: username,
        email: email,
        password: password,
        avatarType: AvatarType.red,
      ),
    ).thenAnswer((_) async => '');

    await repository.signUp(
      username: username,
      email: email,
      password: password,
      avatar: avatar,
    );

    verify(
      () => authService.signUp(
        username: username,
        email: email,
        password: password,
        avatarType: AvatarType.red,
      ),
    ).called(1);
  });

  test('sign up, failure', () async {
    when(() => avatarService.getAvatarType(avatar)).thenReturn(AvatarType.red);
    when(
      () => authService.signUp(
        username: username,
        email: email,
        password: password,
        avatarType: AvatarType.red,
      ),
    ).thenThrow('Error...');

    try {
      await repository.signUp(
        username: username,
        email: email,
        password: password,
        avatar: avatar,
      );
    } catch (error) {
      verify(
        () => authService.signUp(
          username: username,
          email: email,
          password: password,
          avatarType: AvatarType.red,
        ),
      ).called(1);
      expect(error, 'Error...');
    }
  });

  test('log out, success', () async {
    when(() => authService.logOut()).thenAnswer((_) async => '');

    await repository.logOut();

    verify(() => authService.logOut()).called(1);
  });

  test('log out, failure', () async {
    when(() => authService.logOut()).thenThrow('Error...');

    try {
      await repository.logOut();
    } catch (error) {
      verify(() => authService.logOut()).called(1);
      expect(error, 'Error...');
    }
  });
}
