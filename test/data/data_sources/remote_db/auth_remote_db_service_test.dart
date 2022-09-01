import 'package:app/data/data_sources/remote_db/firebase/services/fire_auth_service.dart';
import 'package:app/data/data_sources/remote_db/services/auth_remote_db_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFireAuthService extends Mock implements FireAuthService {}

void main() {
  final fireAuthService = MockFireAuthService();
  late AuthRemoteDbService service;

  setUp(() {
    service = AuthRemoteDbService(fireAuthService: fireAuthService);
  });

  tearDown(() {
    reset(fireAuthService);
  });

  test(
    'sign in, should call method from fire auth service responsible for signing in user',
    () async {
      const String email = 'email@example.com';
      const String password = 'password';
      when(
        () => fireAuthService.signIn(email: email, password: password),
      ).thenAnswer((_) async => '');

      await service.signIn(email: email, password: password);

      verify(
        () => fireAuthService.signIn(email: email, password: password),
      ).called(1);
    },
  );

  test(
    'sign up, should call method from fire auth service responsible for signing up user',
    () async {
      const String email = 'email@example.com';
      const String password = 'password';
      when(
        () => fireAuthService.signUp(email: email, password: password),
      ).thenAnswer((_) async => '');

      await service.signUp(email: email, password: password);

      verify(
        () => fireAuthService.signUp(email: email, password: password),
      ).called(1);
    },
  );

  test(
    'send password reset email, should call method from fire auth service responsible for sending password reset email',
    () async {
      const String email = 'email@example.com';
      when(
        () => fireAuthService.sendPasswordResetEmail(email: email),
      ).thenAnswer((_) async => '');

      await service.sendPasswordResetEmail(email: email);

      verify(
        () => fireAuthService.sendPasswordResetEmail(email: email),
      ).called(1);
    },
  );

  test(
    'sign out, should call method from fire auth service responsible for signing out user',
    () async {
      when(
        () => fireAuthService.signOut(),
      ).thenAnswer((_) async => '');

      await service.signOut();

      verify(
        () => fireAuthService.signOut(),
      ).called(1);
    },
  );

  test(
    'delete logged user, should call method from fire auth service responsible for deleting logged user',
    () async {
      const String password = 'password';
      when(
        () => fireAuthService.deleteLoggedUser(password: password),
      ).thenAnswer((_) async => '');

      await service.deleteLoggedUser(password: password);

      verify(
        () => fireAuthService.deleteLoggedUser(password: password),
      ).called(1);
    },
  );
}
