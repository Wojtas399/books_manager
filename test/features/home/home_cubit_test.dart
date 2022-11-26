import 'package:app/features/home/home_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/domain/use_cases/auth/mock_get_logged_user_id_use_case.dart';
import '../../mocks/domain/use_cases/book/mock_initialize_books_of_user_use_case.dart';

void main() {
  final getLoggedUserIdUseCase = MockGetLoggedUserIdUseCase();
  final initializeBooksOfUserUseCase = MockInitializeBooksOfUserUseCase();
  late HomeCubit cubit;

  setUp(() {
    cubit = HomeCubit(
      getLoggedUserIdUseCase: getLoggedUserIdUseCase,
      initializeBooksOfUserUseCase: initializeBooksOfUserUseCase,
    );
  });

  group(
    'initialize',
    () {
      Future<void> methodCall() async {
        await cubit.initialize();
      }

      tearDown(() {
        verify(
          () => getLoggedUserIdUseCase.execute(),
        ).called(1);
      });

      test(
        'logged user does not exist, should do nothing',
        () async {
          getLoggedUserIdUseCase.mock();

          await methodCall();

          verifyNever(
            () => initializeBooksOfUserUseCase.execute(
              userId: any(named: 'userId'),
            ),
          );
        },
      );

      test(
        "logged user exists, should call use case responsible for initializing logged user's books",
        () async {
          const String loggedUserId = 'u1';
          getLoggedUserIdUseCase.mock(loggedUserId: loggedUserId);

          await methodCall();

          verify(
            () => initializeBooksOfUserUseCase.execute(
              userId: loggedUserId,
            ),
          ).called(1);
        },
      );
    },
  );

  test(
    'change page, should update number in state',
    () {
      const int expectedPageNumber = 3;

      cubit.changePage(expectedPageNumber);

      expect(cubit.state, expectedPageNumber);
    },
  );
}
