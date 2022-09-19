import 'package:app/domain/interfaces/auth_interface.dart';
import 'package:app/domain/interfaces/book_interface.dart';
import 'package:app/domain/interfaces/user_interface.dart';
import 'package:app/domain/use_cases/auth/delete_logged_user_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockBookInterface extends Mock implements BookInterface {}

class MockUserInterface extends Mock implements UserInterface {}

class MockAuthInterface extends Mock implements AuthInterface {}

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

    when(
      () => bookInterface.deleteAllUserBooks(userId: any(named: 'userId')),
    ).thenAnswer((_) async => '');
    when(
      () => userInterface.deleteUser(userId: any(named: 'userId')),
    ).thenAnswer((_) async => '');
    when(
      () => authInterface.deleteLoggedUser(password: password),
    ).thenAnswer((_) async => '');
  });

  tearDown(() {
    reset(bookInterface);
    reset(userInterface);
    reset(authInterface);
  });

  test(
    'should do nothing if logged user does not exist',
    () async {
      when(
        () => authInterface.loggedUserId$,
      ).thenAnswer((_) => Stream.value(null));

      await useCase.execute(password: password);

      verifyNever(
        () => bookInterface.deleteAllUserBooks(
          userId: any(named: 'userId'),
        ),
      );
      verifyNever(
        () => userInterface.deleteUser(
          userId: any(named: 'userId'),
        ),
      );
      verifyNever(
        () => authInterface.deleteLoggedUser(password: password),
      );
    },
  );

  test(
    'should call methods responsible for deleting all logged user books, deleting logged user data and for deleting logged user account',
    () async {
      const String loggedUserId = 'u1';
      when(
        () => authInterface.loggedUserId$,
      ).thenAnswer((_) => Stream.value(loggedUserId));

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
