import 'package:app/domain/entities/user.dart';
import 'package:app/features/home/bloc/home_bloc.dart';
import 'package:app/models/bloc_status.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/use_cases/auth/mock_get_logged_user_id_use_case.dart';
import '../../mocks/use_cases/mock_initialize_user_data_use_case.dart';
import '../../mocks/use_cases/user/mock_get_user_use_case.dart';
import '../../mocks/use_cases/user/mock_load_user_use_case.dart';

void main() {
  final getLoggedUserIdUseCase = MockGetLoggedUserIdUseCase();
  final initializeUserDataUseCase = MockInitializeUserDataUseCase();
  final loadUserUseCase = MockLoadUserUseCase();
  final getUserUseCase = MockGetUserUseCase();

  HomeBloc createBloc() {
    return HomeBloc(
      getLoggedUserIdUseCase: getLoggedUserIdUseCase,
      initializeUserDataUseCase: initializeUserDataUseCase,
      loadUserUseCase: loadUserUseCase,
      getUserUseCase: getUserUseCase,
    );
  }

  HomeState createState({
    BlocStatus status = const BlocStatusComplete(),
    int currentPageIndex = 0,
    bool isDarkModeOn = false,
    bool isDarkModeCompatibilityWithSystemOn = false,
  }) {
    return HomeState(
      status: status,
      currentPageIndex: currentPageIndex,
      isDarkModeOn: isDarkModeOn,
      isDarkModeCompatibilityWithSystemOn: isDarkModeCompatibilityWithSystemOn,
    );
  }

  tearDown(() {
    reset(getLoggedUserIdUseCase);
    reset(initializeUserDataUseCase);
    reset(loadUserUseCase);
    reset(getUserUseCase);
  });

  blocTest(
    'initialize, logged user does not exists, should emit appropriate status',
    build: () => createBloc(),
    setUp: () {
      getLoggedUserIdUseCase.mock();
    },
    act: (HomeBloc bloc) {
      bloc.add(
        const HomeEventInitialize(),
      );
    },
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
      ),
      createState(
        status: const BlocStatusLoggedUserNotFound(),
      ),
    ],
  );

  blocTest(
    'initialize, logged user exists, should call use cases responsible for initializing and loading user data and should set initial theme statuses',
    build: () => createBloc(),
    setUp: () {
      getLoggedUserIdUseCase.mock(loggedUserId: 'u1');
      initializeUserDataUseCase.mock();
      loadUserUseCase.mock();
      getUserUseCase.mock(
        user: createUser(
          isDarkModeOn: true,
          isDarkModeCompatibilityWithSystemOn: true,
        ),
      );
    },
    act: (HomeBloc bloc) {
      bloc.add(
        const HomeEventInitialize(),
      );
    },
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
      ),
      createState(
        status: const BlocStatusComplete(),
        isDarkModeOn: true,
        isDarkModeCompatibilityWithSystemOn: true,
      ),
    ],
    verify: (_) {
      verify(
        () => initializeUserDataUseCase.execute(userId: 'u1'),
      ).called(1);
      verify(
        () => loadUserUseCase.execute(userId: 'u1'),
      ).called(1);
      verify(
        () => getUserUseCase.execute(userId: 'u1'),
      ).called(1);
    },
  );

  blocTest(
    'change page, should update current page index in state',
    build: () => createBloc(),
    act: (HomeBloc bloc) {
      bloc.add(
        const HomeEventChangePage(pageIndex: 2),
      );
    },
    expect: () => [
      createState(
        currentPageIndex: 2,
      ),
    ],
  );
}
