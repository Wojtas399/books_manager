import 'package:app/features/internet_connection_checker/bloc/internet_connection_checker_bloc.dart';
import 'package:app/models/bloc_status.dart';
import 'package:test/test.dart';

void main() {
  late InternetConnectionCheckerState state;

  setUp(() {
    state = const InternetConnectionCheckerState(
      status: BlocStatusInitial(),
      hasInternetConnection: false,
    );
  });

  test(
    'copy with status',
    () {
      const BlocStatus expectedStatus = BlocStatusLoading();

      state = state.copyWith(status: expectedStatus);
      final state2 = state.copyWith();

      expect(state.status, expectedStatus);
      expect(
        state2.status,
        const BlocStatusComplete<InternetConnectionCheckerInfo>(),
      );
    },
  );

  test(
    'copy with has internet connection',
    () {
      const bool expectedValue = true;

      state = state.copyWith(hasInternetConnection: expectedValue);
      final state2 = state.copyWith();

      expect(state.hasInternetConnection, expectedValue);
      expect(state2.hasInternetConnection, expectedValue);
    },
  );
}
