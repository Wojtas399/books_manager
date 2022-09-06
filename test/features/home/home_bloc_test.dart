import 'package:app/domain/use_cases/auth/get_logged_user_id_use_case.dart';
import 'package:app/domain/use_cases/initialize_user_data_use_case.dart';
import 'package:app/features/home/bloc/home_bloc.dart';
import 'package:app/models/bloc_status.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetLoggedUserIdUseCase extends Mock
    implements GetLoggedUserIdUseCase {}

class MockInitializeUserDataUseCase extends Mock
    implements InitializeUserDataUseCase {}

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
    'initialize, should emit appropriate status if logged user id is null',
    build: () => createBloc(),
    setUp: () {
      when(
        () => getLoggedUserIdUseCase.execute(),
      ).thenAnswer((_) => Stream.value(null));
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
    'initialize, should call use case responsible for initializing user data if logged user id is not null',
    build: () => createBloc(),
    setUp: () {
      when(
        () => getLoggedUserIdUseCase.execute(),
      ).thenAnswer((_) => Stream.value('u1'));
      when(
        () => initializeUserDataUseCase.execute(userId: 'u1'),
      ).thenAnswer((_) async => '');
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
