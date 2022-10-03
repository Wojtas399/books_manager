import 'package:app/domain/entities/day.dart';
import 'package:app/domain/entities/read_book.dart';
import 'package:app/domain/use_cases/auth/get_logged_user_id_use_case.dart';
import 'package:app/domain/use_cases/day/get_user_days_from_month_use_case.dart';
import 'package:app/domain/use_cases/day/load_user_days_from_month_use_case.dart';
import 'package:app/models/bloc_state.dart';
import 'package:app/models/bloc_status.dart';
import 'package:app/providers/date_provider.dart';
import 'package:app/utils/date_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'calendar_event.dart';
part 'calendar_state.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  late final DateProvider _dateProvider;
  late final GetLoggedUserIdUseCase _getLoggedUserIdUseCase;
  late final LoadUserDaysFromMonthUseCase _loadUserDaysFromMonthUseCase;
  late final GetUserDaysFromMonthUseCase _getUserDaysFromMonthUseCase;

  CalendarBloc({
    required DateProvider dateProvider,
    required GetLoggedUserIdUseCase getLoggedUserIdUseCase,
    required LoadUserDaysFromMonthUseCase loadUserDaysFromMonthUseCase,
    required GetUserDaysFromMonthUseCase getUserDaysFromMonthUseCase,
    BlocStatus status = const BlocStatusInitial(),
    DateTime? todayDate,
    int? displayingMonth,
    int? displayingYear,
    List<Day> userDaysFromMonth = const [],
  }) : super(
          CalendarState(
            status: status,
            todayDate: todayDate,
            displayingMonth: displayingMonth,
            displayingYear: displayingYear,
            userDaysFromMonth: userDaysFromMonth,
          ),
        ) {
    _dateProvider = dateProvider;
    _getLoggedUserIdUseCase = getLoggedUserIdUseCase;
    _loadUserDaysFromMonthUseCase = loadUserDaysFromMonthUseCase;
    _getUserDaysFromMonthUseCase = getUserDaysFromMonthUseCase;
    on<CalendarEventInitialize>(_initialize);
    on<CalendarEventPreviousMonth>(_previousMonth);
    on<CalendarEventNextMonth>(_nextMonth);
  }

  Future<void> _initialize(
    CalendarEventInitialize event,
    Emitter<CalendarState> emit,
  ) async {
    emit(state.copyWithLoadingStatus());
    final String? loggedUserId = await _getLoggedUserId();
    if (loggedUserId == null) {
      emit(state.copyWithLoggedUserNotFoundStatus());
      return;
    }
    final DateTime todayDate = _dateProvider.getNow();
    await _loadLoggedUserDaysFromDateMonth(loggedUserId, todayDate);
    final List<Day> userDaysFromMonth =
        await _getLoggedUserDaysFromDateMonth(loggedUserId, todayDate);
    emit(state.copyWith(
      todayDate: todayDate,
      displayingMonth: todayDate.month,
      displayingYear: todayDate.year,
      userDaysFromMonth: userDaysFromMonth,
    ));
  }

  Future<void> _previousMonth(
    CalendarEventPreviousMonth event,
    Emitter<CalendarState> emit,
  ) async {
    final String? loggedUserId = await _getLoggedUserId();
    final int? displayingMonth = state.displayingMonth;
    final int? displayingYear = state.displayingYear;
    if (loggedUserId == null) {
      emit(state.copyWithLoggedUserNotFoundStatus());
      return;
    }
    if (displayingMonth != null && displayingYear != null) {
      final DateTime dateOfFirstDayInPreviousMonth =
          _dateProvider.getDateOfFirstDayInPreviousMonth(
        month: displayingMonth,
        year: displayingYear,
      );
      await _loadDaysForMonthFromDate(
        dateOfFirstDayInPreviousMonth,
        loggedUserId,
        emit,
      );
    }
  }

  Future<void> _nextMonth(
    CalendarEventNextMonth event,
    Emitter<CalendarState> emit,
  ) async {
    final String? loggedUserId = await _getLoggedUserId();
    final int? displayingMonth = state.displayingMonth;
    final int? displayingYear = state.displayingYear;
    if (loggedUserId == null) {
      emit(state.copyWithLoggedUserNotFoundStatus());
      return;
    }
    if (displayingMonth != null && displayingYear != null) {
      final DateTime dateOfFirstDayInNextMonth =
          _dateProvider.getDateOfFirstDayInNextMonth(
        month: displayingMonth,
        year: displayingYear,
      );
      await _loadDaysForMonthFromDate(
        dateOfFirstDayInNextMonth,
        loggedUserId,
        emit,
      );
    }
  }

  Future<String?> _getLoggedUserId() async {
    return await _getLoggedUserIdUseCase.execute().first;
  }

  Future<void> _loadDaysForMonthFromDate(
    DateTime date,
    String loggedUserId,
    Emitter<CalendarState> emit,
  ) async {
    emit(state.copyWithLoadingStatus());
    await _loadLoggedUserDaysFromDateMonth(loggedUserId, date);
    final List<Day> userDaysFromMonth =
        await _getLoggedUserDaysFromDateMonth(loggedUserId, date);
    emit(state.copyWith(
      displayingMonth: date.month,
      displayingYear: date.year,
      userDaysFromMonth: userDaysFromMonth,
    ));
  }

  Future<void> _loadLoggedUserDaysFromDateMonth(
    String loggedUserId,
    DateTime date,
  ) async {
    await _loadUserDaysFromMonthUseCase.execute(
      userId: loggedUserId,
      month: date.month,
      year: date.year,
    );
  }

  Future<List<Day>> _getLoggedUserDaysFromDateMonth(
    String loggedUserId,
    DateTime date,
  ) async {
    return await _getUserDaysFromMonthUseCase
        .execute(
          userId: loggedUserId,
          month: date.month,
          year: date.year,
        )
        .first;
  }
}
