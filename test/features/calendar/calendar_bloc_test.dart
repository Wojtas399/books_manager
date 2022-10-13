import 'package:app/domain/entities/day.dart';
import 'package:app/features/calendar/bloc/calendar_bloc.dart';
import 'package:app/models/bloc_status.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/providers/mock_date_provider.dart';
import '../../mocks/use_cases/auth/mock_get_logged_user_id_use_case.dart';
import '../../mocks/use_cases/book/mock_load_all_user_books_use_case.dart';
import '../../mocks/use_cases/day/mock_get_user_days_from_month_use_case.dart';
import '../../mocks/use_cases/day/mock_load_user_days_from_month_use_case.dart';

void main() {
  final dateProvider = MockDateProvider();
  final getLoggedUserIdUseCase = MockGetLoggedUserIdUseCase();
  final loadAllUserBooksUseCase = MockLoadAllUserBooksUseCase();
  final loadUserDaysFromMonthUseCase = MockLoadUserDaysFromMonthUseCase();
  final getUserDaysFromMonthUseCase = MockGetUserDaysFromMonthUseCase();
  const String loggedUserId = 'u1';

  CalendarBloc createBloc() {
    return CalendarBloc(
      dateProvider: dateProvider,
      getLoggedUserIdUseCase: getLoggedUserIdUseCase,
      loadAllUserBooksUseCase: loadAllUserBooksUseCase,
      loadUserDaysFromMonthUseCase: loadUserDaysFromMonthUseCase,
      getUserDaysFromMonthUseCase: getUserDaysFromMonthUseCase,
    );
  }

  CalendarState createState({
    BlocStatus status = const BlocStatusComplete(),
    DateTime? todayDate,
    List<Day> daysOfReading = const [],
  }) {
    return CalendarState(
      status: status,
      todayDate: todayDate,
      daysOfReading: daysOfReading,
    );
  }

  setUp(() {
    loadUserDaysFromMonthUseCase.mock();
  });

  tearDown(() {
    reset(dateProvider);
    reset(getLoggedUserIdUseCase);
    reset(loadAllUserBooksUseCase);
    reset(loadUserDaysFromMonthUseCase);
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

      blocTest(
        'logged user does not exist, should emit appropriate bloc status',
        build: () => createBloc(),
        setUp: () {
          getLoggedUserIdUseCase.mock();
        },
        act: (CalendarBloc bloc) {
          bloc.add(
            const CalendarEventInitialize(),
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
        'logged user exists, should load all logged user books and days from current, previous and next months and then should assign these days to state with today date',
        build: () => createBloc(),
        setUp: () {
          getLoggedUserIdUseCase.mock(loggedUserId: loggedUserId);
          loadAllUserBooksUseCase.mock();
          dateProvider.mockGetNow(
            nowDateTime: todayDate,
          );
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
        act: (CalendarBloc bloc) {
          bloc.add(
            const CalendarEventInitialize(),
          );
        },
        expect: () => [
          createState(
            status: const BlocStatusLoading(),
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
            () => loadAllUserBooksUseCase.execute(
              userId: loggedUserId,
            ),
          ).called(1);
          verify(
            () => loadUserDaysFromMonthUseCase.execute(
              userId: loggedUserId,
              month: 1,
              year: 2022,
            ),
          ).called(1);
          verify(
            () => loadUserDaysFromMonthUseCase.execute(
              userId: loggedUserId,
              month: 12,
              year: 2021,
            ),
          ).called(1);
          verify(
            () => loadUserDaysFromMonthUseCase.execute(
              userId: loggedUserId,
              month: 2,
              year: 2022,
            ),
          ).called(1);
        },
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

      blocTest(
        'should emit appropriate info if logged user does not exist',
        build: () => createBloc(),
        setUp: () {
          getLoggedUserIdUseCase.mock();
        },
        act: (CalendarBloc bloc) {
          bloc.add(
            const CalendarEventMonthChanged(month: 1, year: 2022),
          );
        },
        expect: () => [
          createState(
            status: const BlocStatusLoggedUserNotFound(),
          ),
        ],
      );

      blocTest(
        'should load logged user days from given, previous and next months and should assign these days to state',
        build: () => createBloc(),
        setUp: () {
          getLoggedUserIdUseCase.mock(loggedUserId: loggedUserId);
          loadUserDaysFromMonthUseCase.mock();
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
        act: (CalendarBloc bloc) {
          bloc.add(
            const CalendarEventMonthChanged(month: month, year: year),
          );
        },
        expect: () => [
          createState(
            status: const BlocStatusLoading(),
          ),
          createState(
            daysOfReading: [
              ...userDaysFromPreviousMonth,
              ...userDaysFromGivenMonth,
              ...userDaysFromNextMonth,
            ],
          ),
        ],
        verify: (_) {
          verify(
            () => loadUserDaysFromMonthUseCase.execute(
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
