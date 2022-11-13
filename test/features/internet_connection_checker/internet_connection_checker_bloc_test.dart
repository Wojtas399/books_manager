import 'package:app/features/internet_connection_checker/bloc/internet_connection_checker_bloc.dart';
import 'package:app/models/bloc_status.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/models/mock_device.dart';

void main() {
  final device = MockDevice();

  InternetConnectionCheckerBloc createBloc({
    bool hasInternetConnection = true,
  }) {
    return InternetConnectionCheckerBloc(
      device: device,
      hasInternetConnection: hasInternetConnection,
    );
  }

  InternetConnectionCheckerState createState({
    BlocStatus status = const BlocStatusInitial(),
    bool hasInternetConnection = true,
  }) {
    return InternetConnectionCheckerState(
      status: status,
      hasInternetConnection: hasInternetConnection,
    );
  }

  tearDown(() {
    reset(device);
  });

  blocTest(
    'initialize, should set listener for internet connection',
    build: () => createBloc(),
    setUp: () {
      device.mockInternetConnectionListener(hasInternetConnection: true);
    },
    act: (InternetConnectionCheckerBloc bloc) {
      bloc.add(
        const InternetConnectionCheckerEventInitialize(),
      );
    },
    expect: () => [
      createState(
        status: const BlocStatusComplete<InternetConnectionCheckerInfo>(),
        hasInternetConnection: true,
      ),
    ],
    verify: (_) {
      verify(
        () => device.internetConnectionListener$,
      ).called(1);
    },
  );

  blocTest(
    'connection status changed, should update connection status in state',
    build: () => createBloc(),
    act: (InternetConnectionCheckerBloc bloc) {
      bloc.add(
        const InternetConnectionCheckerEventConnectionStatusChanged(
          hasInternetConnection: true,
        ),
      );
    },
    expect: () => [
      createState(
        status: const BlocStatusComplete<InternetConnectionCheckerInfo>(),
        hasInternetConnection: true,
      ),
    ],
  );

  group(
    'check internet connection status',
    () {
      void eventCall(InternetConnectionCheckerBloc bloc) => bloc.add(
            const InternetConnectionCheckerEventCheckInternetConnection(),
          );

      tearDown(() {
        verify(
          () => device.hasInternetConnection(),
        ).called(1);
      });

      blocTest(
        'should load and update internet connection status',
        build: () => createBloc(),
        setUp: () {
          device.mockHasInternetConnection(value: true);
        },
        act: (InternetConnectionCheckerBloc bloc) => eventCall(bloc),
        wait: const Duration(seconds: 3),
        expect: () => [
          createState(
            status: const BlocStatusLoading(),
          ),
          createState(
            status: const BlocStatusComplete<InternetConnectionCheckerInfo>(),
            hasInternetConnection: true,
          ),
        ],
      );

      blocTest(
        'should emit appropriate info if there is still no internet connection',
        build: () => createBloc(hasInternetConnection: false),
        setUp: () {
          device.mockHasInternetConnection(value: false);
        },
        act: (InternetConnectionCheckerBloc bloc) => eventCall(bloc),
        wait: const Duration(seconds: 3),
        expect: () => [
          createState(
            status: const BlocStatusLoading(),
            hasInternetConnection: false,
          ),
          createState(
            status: const BlocStatusComplete<InternetConnectionCheckerInfo>(
              info: InternetConnectionCheckerInfo.stillHasNotInternetConnection,
            ),
            hasInternetConnection: false,
          ),
        ],
      );
    },
  );
}
