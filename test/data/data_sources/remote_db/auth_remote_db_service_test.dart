import 'package:app/data/data_sources/remote_db/auth_remote_db_service.dart';
import 'package:app/data/data_sources/remote_db/firebase/services/firebase_auth_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseAuthService extends Mock implements FirebaseAuthService {}

void main() {
  final firebaseAuthService = MockFirebaseAuthService();
  late AuthRemoteDbService service;

  setUp(() {
    service = AuthRemoteDbService(firebaseAuthService: firebaseAuthService);
  });

  tearDown(() {
    reset(firebaseAuthService);
  });

  test(
    'sign in, should call method from firebase auth service responsible for signing in user',
    () async {
      const String email = 'email@example.com';
      const String password = 'password';
      when(
        () => firebaseAuthService.signIn(email: email, password: password),
      ).thenAnswer((_) async => '');

      await service.signIn(email: email, password: password);

      verify(
        () => firebaseAuthService.signIn(email: email, password: password),
      ).called(1);
    },
  );

  test(
    'sign up, should call method from firebase auth service responsible for signing up user',
    () async {
      const String email = 'email@example.com';
      const String password = 'password';
      when(
        () => firebaseAuthService.signUp(email: email, password: password),
      ).thenAnswer((_) async => '');

      await service.signUp(email: email, password: password);

      verify(
        () => firebaseAuthService.signUp(email: email, password: password),
      ).called(1);
    },
  );

  test(
    'send password reset email, should call method from firebase auth service responsible for sending password reset email',
    () async {
      const String email = 'email@example.com';
      when(
        () => firebaseAuthService.sendPasswordResetEmail(email: email),
      ).thenAnswer((_) async => '');

      await service.sendPasswordResetEmail(email: email);

      verify(
        () => firebaseAuthService.sendPasswordResetEmail(email: email),
      ).called(1);
    },
  );

  test(
    'sign out, should call method from firebase auth service responsible for signing out user',
    () async {
      when(
        () => firebaseAuthService.signOut(),
      ).thenAnswer((_) async => '');

      await service.signOut();

      verify(
        () => firebaseAuthService.signOut(),
      ).called(1);
    },
  );

  test(
    'delete logged user, should call method from firebase auth service responsible for deleting logged user',
    () async {
      const String password = 'password';
      when(
        () => firebaseAuthService.deleteLoggedUser(password: password),
      ).thenAnswer((_) async => '');

      await service.deleteLoggedUser(password: password);

      verify(
        () => firebaseAuthService.deleteLoggedUser(password: password),
      ).called(1);
    },
  );
}
