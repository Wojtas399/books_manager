import 'package:app/config/errors.dart';
import 'package:app/domain/use_cases/auth/delete_logged_user_use_case.dart';
import 'package:app/models/error.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks/interfaces/mock_auth_interface.dart';
import '../../../mocks/interfaces/mock_book_interface.dart';
import '../../../mocks/interfaces/mock_user_interface.dart';
import '../../../mocks/mock_device.dart';

void main() {
  final device = MockDevice();
  final bookInterface = MockBookInterface();
  final userInterface = MockUserInterface();
  final authInterface = MockAuthInterface();
  late DeleteLoggedUserUseCase useCase;
  const String password = 'password123';

  setUp(() {
    useCase = DeleteLoggedUserUseCase(
      device: device,
      bookInterface: bookInterface,
      userInterface: userInterface,
      authInterface: authInterface,
    );

    bookInterface.mockDeleteAllUserBooks();
    userInterface.mockDeleteUser();
    authInterface.mockDeleteLoggedUser();
  });

  tearDown(() {
    reset(device);
    reset(bookInterface);
    reset(userInterface);
    reset(authInterface);
  });

  test(
    'device has not internet connection, should throw network error',
    () async {
      device.mockHasDeviceInternetConnection(value: false);

      try {
        await useCase.execute(password: password);
      } on NetworkError catch (networkError) {
        expect(
          networkError,
          const NetworkError(code: NetworkErrorCode.lossOfConnection),
        );
      }
    },
  );

  test(
    'device has internet connection, logged user does not exist, should throw auth error with user not found error code',
    () async {
      device.mockHasDeviceInternetConnection(value: true);
      authInterface.mockGetLoggedUserId(loggedUserId: null);

      try {
        await useCase.execute(password: password);
      } on AuthError catch (authError) {
        expect(
          authError,
          const AuthError(code: AuthErrorCode.userNotFound),
        );
      }
    },
  );

  test(
    'device has internet connection, logged user exists, password is wrong, should throw auth error with wrong password error code',
    () async {
      device.mockHasDeviceInternetConnection(value: true);
      authInterface.mockGetLoggedUserId(loggedUserId: 'u1');
      authInterface.mockCheckLoggedUserPasswordCorrectness(
        isPasswordCorrect: false,
      );

      try {
        await useCase.execute(password: password);
      } on AuthError catch (authError) {
        expect(
          authError,
          const AuthError(code: AuthErrorCode.wrongPassword),
        );
      }
    },
  );

  test(
    'device has internet connection, logged user exists, password is correct, should call methods responsible for deleting all logged user books, deleting logged user data and for deleting logged user account',
    () async {
      const String loggedUserId = 'u1';
      device.mockHasDeviceInternetConnection(value: true);
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
