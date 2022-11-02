import 'package:app/config/errors.dart';
import 'package:app/domain/use_cases/auth/delete_logged_user_use_case.dart';
import 'package:app/models/error.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks/domain/interfaces/mock_auth_interface.dart';
import '../../../mocks/domain/interfaces/mock_book_interface.dart';
import '../../../mocks/domain/interfaces/mock_user_interface.dart';

void main() {
  final bookInterface = MockBookInterface();
  final userInterface = MockUserInterface();
  final authInterface = MockAuthInterface();
  late DeleteLoggedUserUseCase useCase;
  const String password = 'password123';

  setUp(() {
    useCase = DeleteLoggedUserUseCase(
      bookInterface: bookInterface,
      userInterface: userInterface,
      authInterface: authInterface,
    );

    bookInterface.mockDeleteAllUserBooks();
    userInterface.mockDeleteUser();
    authInterface.mockDeleteLoggedUser();
  });

  tearDown(() {
    reset(bookInterface);
    reset(userInterface);
    reset(authInterface);
  });

  test(
    'logged user does not exist, should throw auth error with user not found error code',
    () async {
      authInterface.mockGetLoggedUserId(loggedUserId: null);

      AuthError? authError;
      try {
        await useCase.execute(password: password);
      } on AuthError catch (error) {
        authError = error;
      }

      expect(
        authError,
        const AuthError(code: AuthErrorCode.userNotFound),
      );
    },
  );

  test(
    'logged user exists, password is wrong, should throw auth error with wrong password error code',
    () async {
      authInterface.mockGetLoggedUserId(loggedUserId: 'u1');
      authInterface.mockCheckLoggedUserPasswordCorrectness(
        isPasswordCorrect: false,
      );

      AuthError? authError;
      try {
        await useCase.execute(password: password);
      } on AuthError catch (error) {
        authError = error;
      }

      expect(
        authError,
        const AuthError(code: AuthErrorCode.wrongPassword),
      );
    },
  );

  test(
    'logged user exists, password is correct, should call methods responsible for deleting all logged user books, deleting logged user data and for deleting logged user account',
    () async {
      const String loggedUserId = 'u1';
      authInterface.mockGetLoggedUserId(loggedUserId: loggedUserId);
      authInterface.mockCheckLoggedUserPasswordCorrectness(
        isPasswordCorrect: true,
      );

      await useCase.execute(password: password);

      verify(
        () => bookInterface.deleteAllUserBooks(userId: loggedUserId),
      ).called(1);
      verify(
        () => userInterface.deleteUser(userId: loggedUserId),
      ).called(1);
      verify(
        () => authInterface.deleteLoggedUser(password: password),
      ).called(1);
    },
  );
}
