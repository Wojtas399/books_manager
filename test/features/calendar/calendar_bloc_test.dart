import 'package:app/domain/entities/day.dart';
import 'package:app/features/calendar/bloc/calendar_bloc.dart';
import 'package:app/models/bloc_status.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/domain/use_cases/auth/mock_get_logged_user_id_use_case.dart';
import '../../mocks/domain/use_cases/day/mock_get_user_days_from_month_use_case.dart';
import '../../mocks/providers/mock_date_provider.dart';

void main() {
  final dateProvider = MockDateProvider();
  final getLoggedUserIdUseCase = MockGetLoggedUserIdUseCase();
  final getUserDaysFromMonthUseCase = MockGetUserDaysFromMonthUseCase();
  const String loggedUserId = 'u1';

  CalendarBloc createBloc() {
    return CalendarBloc(
      dateProvider: dateProvider,
      getLoggedUserIdUseCase: getLoggedUserIdUseCase,
      getUserDaysFromMonthUseCase: getUserDaysFromMonthUseCase,
    );
  }

  CalendarState createState({
    BlocStatus status = const BlocStatusInitial(),
    DateTime? todayDate,
    List<Day>? daysOfReading,
  }) {
    return CalendarState(
      status: status,
      todayDate: todayDate,
      daysOfReading: daysOfReading,
    );
  }

  tearDown(() {
    reset(dateProvider);
    reset(getLoggedUserIdUseCase);
    reset(getUserDaysFromMonthUseCase);
  });

  group(
    'initialize',
    () {
      final DateTime todayDate = DateTime(2022, 1, 20);
      final List<Day> userDaysFromCurrentMonth = [
        createDay(
          date: todayDate,
        ),
        createDay(
          date: DateTime(todayDate.year, todayDate.month, 15),
        ),
      ];
      final List<Day> userDaysFromPreviousMonth = [
        createDay(
          date: DateTime(2021, 12, 30),
        ),
      ];
      final List<Day> userDaysFromNextMonth = [
        createDay(
          date: DateTime(2022, 2, 20),
        ),
        createDay(
          date: DateTime(2022, 2, 15),
        ),
      ];

      void eventCall(CalendarBloc bloc) {
        bloc.add(
          const CalendarEventInitialize(),
        );
      }

      setUp(() {
        dateProvider.mockGetNow(nowDateTime: todayDate);
      });

      blocTest(
        'logged user does not exist, should emit today date and days as null',
        build: () => createBloc(),
        setUp: () {
          getLoggedUserIdUseCase.mock();
        },
        act: (CalendarBloc bloc) => eventCall(bloc),
        expect: () => [
          createState(
            status: const BlocStatusLoading(),
            todayDate: todayDate,
          ),
          createState(
            status: const BlocStatusComplete(),
            todayDate: todayDate,
            daysOfReading: null,
          ),
        ],
      );

      blocTest(
        'should assign today date to state and should set listener of logged user days from current, previous and next months',
        build: () => createBloc(),
        setUp: () {
          getLoggedUserIdUseCase.mock(loggedUserId: loggedUserId);
          when(
            () => getUserDaysFromMonthUseCase.execute(
              userId: loggedUserId,
              month: 1,
              year: 2022,
            ),
          ).thenAnswer((_) => Stream.value(userDaysFromCurrentMonth));
          when(
            () => getUserDaysFromMonthUseCase.execute(
              userId: loggedUserId,
              month: 12,
              year: 2021,
            ),
          ).thenAnswer((_) => Stream.value(userDaysFromPreviousMonth));
          when(
            () => getUserDaysFromMonthUseCase.execute(
              userId: loggedUserId,
              month: 2,
              year: 2022,
            ),
          ).thenAnswer((_) => Stream.value(userDaysFromNextMonth));
        },
        act: (CalendarBloc bloc) => eventCall(bloc),
        expect: () => [
          createState(
            status: const BlocStatusLoading(),
            todayDate: todayDate,
          ),
          createState(
            status: const BlocStatusComplete(),
            todayDate: todayDate,
            daysOfReading: [
              ...userDaysFromPreviousMonth,
              ...userDaysFromCurrentMonth,
              ...userDaysFromNextMonth,
            ],
          ),
        ],
        verify: (_) {
          verify(
            () => getUserDaysFromMonthUseCase.execute(
              userId: loggedUserId,
              month: any(named: 'month'),
              year: any(named: 'year'),
            ),
          ).called(3);
        },
      );
    },
  );

  group(
    'days of reading updated',
    () {
      final List<Day> daysOfReading = [
        createDay(
          date: DateTime(2022, 10, 20),
        ),
        createDay(
          date: DateTime(2022, 10, 15),
        ),
      ];

      blocTest(
        'should update days of reading in state',
        build: () => createBloc(),
        act: (CalendarBloc bloc) {
          bloc.add(
            CalendarEventDaysOfReadingUpdated(daysOfReading: daysOfReading),
          );
        },
        expect: () => [
          createState(
            status: const BlocStatusComplete(),
            daysOfReading: daysOfReading,
          ),
        ],
      );
    },
  );

  group(
    'month changed',
    () {
      const String loggedUserId = 'u1';
      const int month = 12;
      const int year = 2021;
      final List<Day> userDaysFromGivenMonth = [
        createDay(
          date: DateTime(year, month, 10),
        ),
        createDay(
          date: DateTime(year, month, 5),
        ),
      ];
      final List<Day> userDaysFromPreviousMonth = [
        createDay(
          date: DateTime(year, month - 1, 23),
        ),
      ];
      final List<Day> userDaysFromNextMonth = [
        createDay(
          date: DateTime(year, month + 1, 12),
        ),
      ];

      void eventCall(CalendarBloc bloc) {
        bloc.add(
          const CalendarEventMonthChanged(month: month, year: year),
        );
      }

      blocTest(
        'logged user does not exist, should emit days as null',
        build: () => createBloc(),
        setUp: () {
          getLoggedUserIdUseCase.mock();
        },
        act: (CalendarBloc bloc) => eventCall(bloc),
        expect: () => [
          createState(
            status: const BlocStatusLoading(),
          ),
          createState(
            status: const BlocStatusComplete(),
            daysOfReading: null,
          ),
        ],
      );

      blocTest(
        'should change listener of logged user days from given, previous and next months and should assign these days to state',
        build: () => createBloc(),
        setUp: () {
          getLoggedUserIdUseCase.mock(loggedUserId: loggedUserId);
          when(
            () => getUserDaysFromMonthUseCase.execute(
              userId: loggedUserId,
              month: month,
              year: year,
            ),
          ).thenAnswer((_) => Stream.value(userDaysFromGivenMonth));
          when(
            () => getUserDaysFromMonthUseCase.execute(
              userId: loggedUserId,
              month: 11,
              year: 2021,
            ),
          ).thenAnswer((_) => Stream.value(userDaysFromPreviousMonth));
          when(
            () => getUserDaysFromMonthUseCase.execute(
              userId: loggedUserId,
              month: 1,
              year: 2022,
            ),
          ).thenAnswer((_) => Stream.value(userDaysFromNextMonth));
        },
        act: (CalendarBloc bloc) => eventCall(bloc),
        expect: () => [
          createState(
            status: const BlocStatusLoading(),
          ),
          createState(
            status: const BlocStatusComplete(),
            daysOfReading: [
              ...userDaysFromPreviousMonth,
              ...userDaysFromGivenMonth,
              ...userDaysFromNextMonth,
            ],
          ),
        ],
        verify: (_) {
          verify(
            () => getUserDaysFromMonthUseCase.execute(
              userId: loggedUserId,
              month: month,
              year: year,
            ),
          ).called(1);
          verify(
            () => getUserDaysFromMonthUseCase.execute(
              userId: loggedUserId,
              month: 11,
              year: 2021,
            ),
          ).called(1);
          verify(
            () => getUserDaysFromMonthUseCase.execute(
              userId: loggedUserId,
              month: 1,
              year: 2022,
            ),
          ).called(1);
        },
      );
    },
  );
}
