import 'package:app/domain/entities/day.dart';
import 'package:app/domain/entities/read_book.dart';
import 'package:app/domain/use_cases/auth/get_logged_user_id_use_case.dart';
import 'package:app/domain/use_cases/book/load_all_user_books_use_case.dart';
import 'package:app/domain/use_cases/day/get_user_days_from_month_use_case.dart';
import 'package:app/domain/use_cases/day/load_user_days_from_month_use_case.dart';
import 'package:app/models/bloc_state.dart';
import 'package:app/models/bloc_status.dart';
import 'package:app/models/custom_bloc.dart';
import 'package:app/providers/date_provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'calendar_event.dart';
part 'calendar_state.dart';

class CalendarBloc extends CustomBloc<CalendarEvent, CalendarState> {
  late final DateProvider _dateProvider;
  late final GetLoggedUserIdUseCase _getLoggedUserIdUseCase;
  late final LoadAllUserBooksUseCase _loadAllUserBooksUseCase;
  late final LoadUserDaysFromMonthUseCase _loadUserDaysFromMonthUseCase;
  late final GetUserDaysFromMonthUseCase _getUserDaysFromMonthUseCase;

  CalendarBloc({
    required DateProvider dateProvider,
    required GetLoggedUserIdUseCase getLoggedUserIdUseCase,
    required LoadAllUserBooksUseCase loadAllUserBooksUseCase,
    required LoadUserDaysFromMonthUseCase loadUserDaysFromMonthUseCase,
    required GetUserDaysFromMonthUseCase getUserDaysFromMonthUseCase,
    BlocStatus status = const BlocStatusInitial(),
    DateTime? todayDate,
    List<Day> daysOfReading = const [],
  }) : super(
          CalendarState(
            status: status,
            todayDate: todayDate,
            daysOfReading: daysOfReading,
          ),
        ) {
    _dateProvider = dateProvider;
    _getLoggedUserIdUseCase = getLoggedUserIdUseCase;
    _loadAllUserBooksUseCase = loadAllUserBooksUseCase;
    _loadUserDaysFromMonthUseCase = loadUserDaysFromMonthUseCase;
    _getUserDaysFromMonthUseCase = getUserDaysFromMonthUseCase;
    on<CalendarEventInitialize>(_initialize);
    on<CalendarEventMonthChanged>(_monthChanged);
  }

  Future<void> _initialize(
    CalendarEventInitialize event,
    Emitter<CalendarState> emit,
  ) async {
    emitLoadingStatus(emit);
    final String? loggedUserId = await _getLoggedUserId();
    if (loggedUserId == null) {
      emitLoggedUserNotFoundStatus(emit);
      return;
    }
    final DateTime todayDate = _dateProvider.getNow();
    await _loadAllUserBooksUseCase.execute(userId: loggedUserId);
    await _loadLoggedUserDaysFromGivenMonthPreviousAndNext(
      loggedUserId,
      todayDate.month,
      todayDate.year,
    );
    final List<Day> daysOfReading =
        await _getLoggedUserDaysFromGivenMonthPreviousAndNext(
      loggedUserId,
      todayDate.month,
      todayDate.year,
    );
    emit(state.copyWith(
      todayDate: todayDate,
      daysOfReading: daysOfReading,
    ));
  }

  Future<void> _monthChanged(
    CalendarEventMonthChanged event,
    Emitter<CalendarState> emit,
  ) async {
    final String? loggedUserId = await _getLoggedUserId();
    if (loggedUserId == null) {
      emitLoggedUserNotFoundStatus(emit);
      return;
    }
    emitLoadingStatus(emit);
    await _loadLoggedUserDaysFromGivenMonthPreviousAndNext(
      loggedUserId,
      event.month,
      event.year,
    );
    final List<Day> daysOfReading =
        await _getLoggedUserDaysFromGivenMonthPreviousAndNext(
      loggedUserId,
      event.month,
      event.year,
    );
    emit(state.copyWith(
      daysOfReading: daysOfReading,
    ));
  }

  Future<String?> _getLoggedUserId() async {
    return await _getLoggedUserIdUseCase.execute().first;
  }

  Future<void> _loadLoggedUserDaysFromGivenMonthPreviousAndNext(
    String loggedUserId,
    int month,
    int year,
  ) async {
    final DateTime previousMonthDate = DateTime(year, month - 1);
    final DateTime nextMonthDate = DateTime(year, month + 1);
    await _loadUserDaysFromMonthUseCase.execute(
      userId: loggedUserId,
      month: month,
      year: year,
    );
    await _loadUserDaysFromMonthUseCase.execute(
      userId: loggedUserId,
      month: previousMonthDate.month,
      year: previousMonthDate.year,
    );
    await _loadUserDaysFromMonthUseCase.execute(
      userId: loggedUserId,
      month: nextMonthDate.month,
      year: nextMonthDate.year,
    );
  }

  Future<List<Day>> _getLoggedUserDaysFromGivenMonthPreviousAndNext(
    String loggedUserId,
    int month,
    int year,
  ) async {
    final DateTime previousMonthDate = DateTime(year, month - 1);
    final DateTime nextMonthDate = DateTime(year, month + 1);
    final List<Day> daysFromGivenMonth = await _getUserDaysFromMonthUseCase
        .execute(
          userId: loggedUserId,
          month: month,
          year: year,
        )
        .first;
    final List<Day> daysFromPreviousMonth = await _getUserDaysFromMonthUseCase
        .execute(
          userId: loggedUserId,
          month: previousMonthDate.month,
          year: previousMonthDate.year,
        )
        .first;
    final List<Day> daysFromNextMonth = await _getUserDaysFromMonthUseCase
        .execute(
          userId: loggedUserId,
          month: nextMonthDate.month,
          year: nextMonthDate.year,
        )
        .first;
    return [
      ...daysFromPreviousMonth,
      ...daysFromGivenMonth,
      ...daysFromNextMonth,
    ];
  }
}
