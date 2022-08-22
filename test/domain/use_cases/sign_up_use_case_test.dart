import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:app/domain/use_cases/auth/sign_up_use_case.dart';
import 'package:app/interfaces/auth_interface.dart';
import 'package:app/interfaces/user_interface.dart';
import 'package:app/models/avatar.dart';

class MockAuthInterface extends Mock implements AuthInterface {}

class MockUserInterface extends Mock implements UserInterface {}

void main() {
  final authInterface = MockAuthInterface();
  final userInterface = MockUserInterface();
  final useCase = SignUpUseCase(
    authInterface: authInterface,
    userInterface: userInterface,
  );

  test(
    'should call methods responsible for signing up user and for setting user data',
    () async {
      final Avatar avatar = FileAvatar(file: File('path'));
      const String username = 'username';
      const String email = 'email@example.com';
      const String password = 'password123';
      when(
        () => authInterface.signUp(
          email: email,
          password: password,
        ),
      ).thenAnswer((_) async => '');
      when(
        () => userInterface.setUserData(
          username: username,
          avatar: avatar,
        ),
      ).thenAnswer((_) async => '');

      await useCase.execute(
        avatar: avatar,
        username: username,
        email: email,
        password: password,
      );

      verify(
        () => authInterface.signUp(
          email: email,
          password: password,
        ),
      ).called(1);
      verify(
        () => userInterface.setUserData(
          username: username,
          avatar: avatar,
        ),
      ).called(1);
    },
  );
}
