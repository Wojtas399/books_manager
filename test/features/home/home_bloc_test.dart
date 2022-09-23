import 'package:app/features/home/bloc/home_bloc.dart';
import 'package:app/models/bloc_status.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/use_cases/auth/mock_get_logged_user_id_use_case.dart';
import '../../mocks/use_cases/mock_initialize_user_data_use_case.dart';

void main() {
  final getLoggedUserIdUseCase = MockGetLoggedUserIdUseCase();
  final initializeUserDataUseCase = MockInitializeUserDataUseCase();

  HomeBloc createBloc() {
    return HomeBloc(
      getLoggedUserIdUseCase: getLoggedUserIdUseCase,
      initializeUserDataUseCase: initializeUserDataUseCase,
    );
  }

  HomeState createState({
    BlocStatus status = const BlocStatusComplete(),
    int currentPageIndex = 0,
  }) {
    return HomeState(
      status: status,
      currentPageIndex: currentPageIndex,
    );
  }

  tearDown(() {
    reset(getLoggedUserIdUseCase);
    reset(initializeUserDataUseCase);
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
    'initialize, logged user exists, should call use cases responsible for initializing user data',
    build: () => createBloc(),
    setUp: () {
      getLoggedUserIdUseCase.mock(loggedUserId: 'u1');
      initializeUserDataUseCase.mock();
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
      ),
    ],
    verify: (_) {
      verify(
        () => initializeUserDataUseCase.execute(userId: 'u1'),
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
