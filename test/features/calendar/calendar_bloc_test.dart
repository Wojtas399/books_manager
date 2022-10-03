import 'package:app/domain/entities/day.dart';
import 'package:app/domain/entities/read_book.dart';
import 'package:app/features/calendar/bloc/calendar_bloc.dart';
import 'package:app/models/bloc_status.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/providers/mock_date_provider.dart';
import '../../mocks/use_cases/auth/mock_get_logged_user_id_use_case.dart';
import '../../mocks/use_cases/day/mock_get_user_days_from_month_use_case.dart';
import '../../mocks/use_cases/day/mock_load_user_days_from_month_use_case.dart';

void main() {
  final dateProvider = MockDateProvider();
  final getLoggedUserIdUseCase = MockGetLoggedUserIdUseCase();
  final loadUserDaysFromMonthUseCase = MockLoadUserDaysFromMonthUseCase();
  final getUserDaysFromMonthUseCase = MockGetUserDaysFromMonthUseCase();
  const String loggedUserId = 'u1';

  CalendarBloc createBloc({
    int? displayingMonth,
    int? displayingYear,
  }) {
    return CalendarBloc(
      dateProvider: dateProvider,
      getLoggedUserIdUseCase: getLoggedUserIdUseCase,
      loadUserDaysFromMonthUseCase: loadUserDaysFromMonthUseCase,
      getUserDaysFromMonthUseCase: getUserDaysFromMonthUseCase,
      displayingMonth: displayingMonth,
      displayingYear: displayingYear,
    );
  }

  CalendarState createState({
    BlocStatus status = const BlocStatusComplete(),
    DateTime? todayDate,
    int? displayingMonth,
    int? displayingYear,
    List<Day> userDaysFromMonth = const [],
  }) {
    return CalendarState(
      status: status,
      todayDate: todayDate,
      displayingMonth: displayingMonth,
      displayingYear: displayingYear,
      userDaysFromMonth: userDaysFromMonth,
    );
  }

  setUp(() {
    loadUserDaysFromMonthUseCase.mock();
  });

  tearDown(() {
    reset(dateProvider);
    reset(getLoggedUserIdUseCase);
    reset(loadUserDaysFromMonthUseCase);
    reset(getUserDaysFromMonthUseCase);
  });

  group(
    'initialize',
    () {
      final DateTime todayDate = DateTime(2022, 9, 20);
      final List<Day> userDaysFromMonth = [
        createDay(
          userId: loggedUserId,
          date: todayDate,
          readBooks: [
            createReadBook(bookId: 'b1', readPagesAmount: 200),
          ],
        ),
        createDay(
          userId: loggedUserId,
          date: DateTime(todayDate.year, todayDate.month, 15),
          readBooks: [
            createReadBook(bookId: 'b1', readPagesAmount: 20),
          ],
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
        'should call use case responsible for loading logged user days from current month and then should assign these days to state with today date, displaying month and displaying year',
        build: () => createBloc(),
        setUp: () {
          getLoggedUserIdUseCase.mock(loggedUserId: loggedUserId);
          dateProvider.mockGetNow(
            nowDateTime: todayDate,
          );
          getUserDaysFromMonthUseCase.mock(
            userDaysFromMonth: userDaysFromMonth,
          );
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
            displayingMonth: todayDate.month,
            displayingYear: todayDate.year,
            userDaysFromMonth: userDaysFromMonth,
          ),
        ],
        verify: (_) {
          verify(
            () => loadUserDaysFromMonthUseCase.execute(
              userId: loggedUserId,
              month: todayDate.month,
              year: todayDate.year,
            ),
          ).called(1);
        },
      );
    },
  );

  blocTest(
    'previous month, logged user does not exist, should emit appropriate bloc status',
    build: () => createBloc(),
    setUp: () {
      getLoggedUserIdUseCase.mock();
    },
    act: (CalendarBloc bloc) {
      bloc.add(
        const CalendarEventPreviousMonth(),
      );
    },
    expect: () => [
      createState(
        status: const BlocStatusLoggedUserNotFound(),
      ),
    ],
  );

  group(
    'previous month, the same year',
    () {
      const int originalMonth = 5;
      const int newMonth = 4;
      const int year = 2022;
      final List<Day> userDaysFromNewMonth = [
        createDay(
          userId: loggedUserId,
          date: DateTime(year, newMonth, 20),
        ),
        createDay(
          userId: loggedUserId,
          date: DateTime(year, newMonth, 18),
        ),
      ];

      blocTest(
        'should change number of displaying month one down and should load new logged user days from new month',
        build: () => createBloc(
          displayingMonth: originalMonth,
          displayingYear: year,
        ),
        setUp: () {
          getLoggedUserIdUseCase.mock(loggedUserId: loggedUserId);
          dateProvider.mockGetDateOfFirstDayInPreviousMonth(
            dateOfFirstDayInPreviousMonth: DateTime(year, newMonth),
          );
          getUserDaysFromMonthUseCase.mock(
            userDaysFromMonth: userDaysFromNewMonth,
          );
        },
        act: (CalendarBloc bloc) {
          bloc.add(
            const CalendarEventPreviousMonth(),
          );
        },
        expect: () => [
          createState(
            status: const BlocStatusLoading(),
            displayingMonth: originalMonth,
            displayingYear: year,
          ),
          createState(
            displayingMonth: newMonth,
            displayingYear: year,
            userDaysFromMonth: userDaysFromNewMonth,
          ),
        ],
      );
    },
  );

  group(
    'previous month, previous year',
    () {
      const int originalMonth = 1;
      const int newMonth = 12;
      const int originalYear = 2022;
      const int newYear = 2021;
      final List<Day> userDaysFromNewMonth = [
        createDay(
          userId: loggedUserId,
          date: DateTime(newYear, newMonth, 20),
        ),
        createDay(
          userId: loggedUserId,
          date: DateTime(newYear, newMonth, 18),
        ),
      ];

      blocTest(
        'should change number of displaying month one down and should load new logged user days from new month',
        build: () => createBloc(
          displayingMonth: originalMonth,
          displayingYear: originalYear,
        ),
        setUp: () {
          getLoggedUserIdUseCase.mock(loggedUserId: loggedUserId);
          dateProvider.mockGetDateOfFirstDayInPreviousMonth(
            dateOfFirstDayInPreviousMonth: DateTime(newYear, newMonth),
          );
          getUserDaysFromMonthUseCase.mock(
            userDaysFromMonth: userDaysFromNewMonth,
          );
        },
        act: (CalendarBloc bloc) {
          bloc.add(
            const CalendarEventPreviousMonth(),
          );
        },
        expect: () => [
          createState(
            status: const BlocStatusLoading(),
            displayingMonth: originalMonth,
            displayingYear: originalYear,
          ),
          createState(
            displayingMonth: newMonth,
            displayingYear: newYear,
            userDaysFromMonth: userDaysFromNewMonth,
          ),
        ],
      );
    },
  );

  blocTest(
    'next month, logged user does not exist, should emit appropriate bloc status',
    build: () => createBloc(),
    setUp: () {
      getLoggedUserIdUseCase.mock();
    },
    act: (CalendarBloc bloc) {
      bloc.add(
        const CalendarEventNextMonth(),
      );
    },
    expect: () => [
      createState(
        status: const BlocStatusLoggedUserNotFound(),
      ),
    ],
  );

  group(
    'next month, the same year',
    () {
      const int originalMonth = 5;
      const int newMonth = 6;
      const int year = 2022;
      final List<Day> userDaysFromNewMonth = [
        createDay(
          userId: loggedUserId,
          date: DateTime(year, newMonth, 20),
        ),
        createDay(
          userId: loggedUserId,
          date: DateTime(year, newMonth, 18),
        ),
      ];

      blocTest(
        'should change number of displaying month one up and should load new logged user days from new month',
        build: () => createBloc(
          displayingMonth: originalMonth,
          displayingYear: year,
        ),
        setUp: () {
          getLoggedUserIdUseCase.mock(loggedUserId: loggedUserId);
          dateProvider.mockGetDateOfFirstDayInNextMonth(
            dateOfFirstDayInNextMonth: DateTime(year, newMonth),
          );
          getUserDaysFromMonthUseCase.mock(
            userDaysFromMonth: userDaysFromNewMonth,
          );
        },
        act: (CalendarBloc bloc) {
          bloc.add(
            const CalendarEventNextMonth(),
          );
        },
        expect: () => [
          createState(
            status: const BlocStatusLoading(),
            displayingMonth: originalMonth,
            displayingYear: year,
          ),
          createState(
            displayingMonth: newMonth,
            displayingYear: year,
            userDaysFromMonth: userDaysFromNewMonth,
          ),
        ],
      );
    },
  );

  group(
    'next month, next year',
    () {
      const int originalMonth = 12;
      const int newMonth = 1;
      const int originalYear = 2022;
      const int newYear = 2023;
      final List<Day> userDaysFromNewMonth = [
        createDay(
          userId: loggedUserId,
          date: DateTime(newYear, newMonth, 20),
        ),
        createDay(
          userId: loggedUserId,
          date: DateTime(newYear, newMonth, 18),
        ),
      ];

      blocTest(
        'should change number of displaying month one up and should load new logged user days from new month',
        build: () => createBloc(
          displayingMonth: originalMonth,
          displayingYear: originalYear,
        ),
        setUp: () {
          getLoggedUserIdUseCase.mock(loggedUserId: loggedUserId);
          dateProvider.mockGetDateOfFirstDayInNextMonth(
            dateOfFirstDayInNextMonth: DateTime(newYear, newMonth),
          );
          getUserDaysFromMonthUseCase.mock(
            userDaysFromMonth: userDaysFromNewMonth,
          );
        },
        act: (CalendarBloc bloc) {
          bloc.add(
            const CalendarEventNextMonth(),
          );
        },
        expect: () => [
          createState(
            status: const BlocStatusLoading(),
            displayingMonth: originalMonth,
            displayingYear: originalYear,
          ),
          createState(
            displayingMonth: newMonth,
            displayingYear: newYear,
            userDaysFromMonth: userDaysFromNewMonth,
          ),
        ],
      );
    },
  );
}
