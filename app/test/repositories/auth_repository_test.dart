import 'package:app/backend/auth_service.dart';
import 'package:app/repositories/auth/auth_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthService extends Mock implements AuthService {}

void main() {
  AuthService authService = MockAuthService();
  late AuthRepository authRepository;

  setUp(() {
    authRepository = AuthRepository(authService: authService);
  });

  tearDown(() => reset(authService));

  group('signIn', () {
    group('success', () {
      setUp(() async {
        when(() => authService.signIn(email: 'email', password: 'password'))
            .thenAnswer((_) async => 'success');
        await authRepository.signIn(email: 'email', password: 'password');
      });

      test('Should call sign in method from auth service', () async {
        verify(() => authService.signIn(email: 'email', password: 'password'))
            .called(1);
      });
    });

    group('failure', () {
      setUp(() async {
        when(() => authService.signIn(email: 'email', password: 'password'))
            .thenThrow('Invalid email or password');
      });

      test('Should throw error', () async {
        try {
          await authRepository.signIn(email: 'email', password: 'password');
        } catch (error) {
          expect(error, 'Invalid email or password');
        }
      });
    });
  });

  group('signUp', () {
    group('success', () {
      setUp(() async {
        when(() => authService.signUp(
            username: 'username',
            email: 'email',
            password: 'password',
            avatar: 'avatar')).thenAnswer((_) async => 'Success');
        await authRepository.signUp(
          username: 'username',
          email: 'email',
          password: 'password',
          avatar: 'avatar',
        );
      });

      test('Should call sign up method from auth service', () async {
        verify(() => authService.signUp(
              username: 'username',
              email: 'email',
              password: 'password',
              avatar: 'avatar',
            )).called(1);
      });
    });

    group('failure', () {
      setUp(() async {
        when(() => authService.signUp(
              username: 'username',
              email: 'email',
              password: 'password',
              avatar: 'avatar',
            )).thenThrow('Error...');
      });

      test('Should throw error', () async {
        try {
          await authRepository.signUp(
            username: 'username',
            email: 'email',
            password: 'password',
            avatar: 'avatar',
          );
        } catch (error) {
          expect(error, 'Error...');
        }
      });
    });
  });

  group('getAvatarUrl', () {
    group('success', () {
      setUp(() async {
        when(() => authService.getAvatarUrl(avatarPath: 'avatar/img.png'))
            .thenAnswer((_) async => 'http://url');
      });

      test('Should return avatar url', () async {
        String url =
            await authRepository.getAvatarUrl(avatarPath: 'avatar/img.png');
        expect(url, 'http://url');
      });
    });

    group('failure', () {
      setUp(() async {
        when(() => authService.getAvatarUrl(avatarPath: 'avatar/img.png'))
            .thenThrow('Error...');
      });

      test('Should throw error', () async {
        try {
          await authRepository.getAvatarUrl(avatarPath: 'avatar/img.png');
        } catch (error) {
          expect(error, 'Error...');
        }
      });
    });
  });

  group('changeAvatar', () {
    group('success', () {
      setUp(() async {
        when(() => authService.changeAvatar(avatar: 'avatar/new.jpg'))
            .thenAnswer((_) async => 'Success');
        await authRepository.changeAvatar(avatar: 'avatar/new.jpg');
      });

      test('Should call change avatar method from auth service', () async {
        verify(() => authService.changeAvatar(avatar: 'avatar/new.jpg'))
            .called(1);
      });
    });

    group('failure', () {
      setUp(() async {
        when(() => authService.changeAvatar(avatar: 'avatar/new.jpg'))
            .thenThrow('Error...');
      });

      test('Should throw error', () async {
        try {
          await authRepository.changeAvatar(avatar: 'avatar/new.jpg');
        } catch (error) {
          expect(error, 'Error...');
        }
      });
    });
  });

  group('changeUsername', () {
    group('success', () {
      setUp(() async {
        when(() => authService.changeUsername(newUsername: 'username'))
            .thenAnswer((_) async => 'Success');
        await authRepository.changeUsername(newUsername: 'username');
      });

      test('Should call update username method from auth service', () async {
        verify(() => authService.changeUsername(newUsername: 'username'))
            .called(1);
      });
    });

    group('failure', () {
      setUp(() async {
        when(() => authService.changeUsername(newUsername: 'username'))
            .thenThrow('Error...');
      });

      test('Should throw error', () async {
        try {
          await authRepository.changeUsername(newUsername: 'username');
        } catch (error) {
          expect(error, 'Error...');
        }
      });
    });
  });

  group('changeEmail', () {
    group('success', () {
      setUp(() async {
        when(() => authService.changeEmail(
              newEmail: 'email@example.com',
              password: 'password',
            )).thenAnswer((_) async => 'Success');
        await authRepository.changeEmail(
          newEmail: 'email@example.com',
          password: 'password',
        );
      });

      test('Should call change email method from auth service', () async {
        verify(() => authService.changeEmail(
              newEmail: 'email@example.com',
              password: 'password',
            )).called(1);
      });
    });

    group('failure', () {
      setUp(() async {
        when(() => authService.changeEmail(
              newEmail: 'email@example.com',
              password: 'password',
            )).thenThrow('Error...');
      });

      test('Should throw error', () async {
        try {
          await authRepository.changeEmail(
            newEmail: 'email@example.com',
            password: 'password',
          );
        } catch (error) {
          expect(error, 'Error...');
        }
      });
    });
  });

  group('changePassword', () {
    group('success', () {
      setUp(() async {
        when(() => authService.changePassword(
              currentPassword: 'password1',
              newPassword: 'newPassword1',
            )).thenAnswer((_) async => 'Succcess');
        await authRepository.changePassword(
          currentPassword: 'password1',
          newPassword: 'newPassword1',
        );
      });

      test('Should call change password method from auth service', () async {
        verify(() => authService.changePassword(
              currentPassword: 'password1',
              newPassword: 'newPassword1',
            )).called(1);
      });
    });

    group('failure', () {
      setUp(() async {
        when(() => authService.changePassword(
              currentPassword: 'password1',
              newPassword: 'newPassword1',
            )).thenThrow('Error...');
      });

      test('Should throw error', () async {
        try {
          await authRepository.changePassword(
            currentPassword: 'password1',
            newPassword: 'newPassword1',
          );
        } catch (error) {
          expect(error, 'Error...');
        }
      });
    });
  });

  group('logOut', () {
    group('success', () {
      setUp(() async {
        when(() => authService.logOut()).thenAnswer((_) async => 'Success');
        await authRepository.logOut();
      });

      test('Should call log out method from auth service', () async {
        verify(() => authService.logOut()).called(1);
      });
    });

    group('failure', () {
      setUp(() async {
        when(() => authService.logOut()).thenThrow('Error...');
      });

      test('Should throw error when something went wrong', () async {
        try {
          await authRepository.logOut();
        } catch (error) {
          expect(error, 'Error...');
        }
      });
    });
  });
}
