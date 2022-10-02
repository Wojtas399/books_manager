import 'package:app/features/calendar/bloc/calendar_bloc.dart';
import 'package:app/models/bloc_status.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/providers/mock_date_provider.dart';

void main() {
  final dateProvider = MockDateProvider();

  CalendarBloc createBloc({
    int? displayingMonth,
    int? displayingYear,
  }) {
    return CalendarBloc(
      dateProvider: dateProvider,
      displayingMonth: displayingMonth,
      displayingYear: displayingYear,
    );
  }

  CalendarState createState({
    BlocStatus status = const BlocStatusComplete(),
    DateTime? todayDate,
    int? displayingMonth,
    int? displayingYear,
  }) {
    return CalendarState(
      status: status,
      todayDate: todayDate,
      displayingMonth: displayingMonth,
      displayingYear: displayingYear,
    );
  }

  tearDown(() {
    reset(dateProvider);
  });

  blocTest(
    'initialize, should load today date, assign them to state and should set displaying month and year',
    build: () => createBloc(),
    setUp: () {
      dateProvider.mockGetNow(
        nowDateTime: DateTime(2022, 9, 20),
      );
    },
    act: (CalendarBloc bloc) {
      bloc.add(
        const CalendarEventInitialize(),
      );
    },
    expect: () => [
      createState(
        todayDate: DateTime(2022, 9, 20),
        displayingMonth: 9,
        displayingYear: 2022,
      ),
    ],
  );

  blocTest(
    'previous month, should change number of displaying month one down',
    build: () => createBloc(
      displayingMonth: 5,
      displayingYear: 2022,
    ),
    act: (CalendarBloc bloc) {
      bloc.add(
        const CalendarEventPreviousMonth(),
      );
    },
    expect: () => [
      createState(
        displayingMonth: 4,
        displayingYear: 2022,
      ),
    ],
  );

  blocTest(
    'previous month, if number of displaying month is equal to 1, should change this number to 12 and should change number of displaying year one down',
    build: () => createBloc(
      displayingMonth: 1,
      displayingYear: 2022,
    ),
    act: (CalendarBloc bloc) {
      bloc.add(
        const CalendarEventPreviousMonth(),
      );
    },
    expect: () => [
      createState(
        displayingMonth: 12,
        displayingYear: 2021,
      ),
    ],
  );

  blocTest(
    'next month, should change number of displaying month one up',
    build: () => createBloc(
      displayingMonth: 5,
      displayingYear: 2022,
    ),
    act: (CalendarBloc bloc) {
      bloc.add(
        const CalendarEventNextMonth(),
      );
    },
    expect: () => [
      createState(
        displayingMonth: 6,
        displayingYear: 2022,
      ),
    ],
  );

  blocTest(
    'next month, if number of displaying month is equal to 12, should change this number to 1 and should change number of displaying year one up',
    build: () => createBloc(
      displayingMonth: 12,
      displayingYear: 2022,
    ),
    act: (CalendarBloc bloc) {
      bloc.add(
        const CalendarEventNextMonth(),
      );
    },
    expect: () => [
      createState(
        displayingMonth: 1,
        displayingYear: 2023,
      ),
    ],
  );
}
