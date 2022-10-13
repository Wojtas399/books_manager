import 'dart:async';

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
import 'package:rxdart/rxdart.dart';

part 'calendar_event.dart';
part 'calendar_state.dart';

class CalendarBloc extends CustomBloc<CalendarEvent, CalendarState> {
  late final DateProvider _dateProvider;
  late final GetLoggedUserIdUseCase _getLoggedUserIdUseCase;
  late final LoadAllUserBooksUseCase _loadAllUserBooksUseCase;
  late final LoadUserDaysFromMonthUseCase _loadUserDaysFromMonthUseCase;
  late final GetUserDaysFromMonthUseCase _getUserDaysFromMonthUseCase;
  StreamSubscription<List<Day>?>? _daysListener;

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
    on<CalendarEventDaysOfReadingUpdated>(_daysOfReadingUpdated);
    on<CalendarEventMonthChanged>(_monthChanged);
  }

  @override
  Future<void> close() async {
    _daysListener?.cancel();
    super.close();
  }

  Future<void> _initialize(
    CalendarEventInitialize event,
    Emitter<CalendarState> emit,
  ) async {
    final String? loggedUserId = await _getLoggedUserId();
    if (loggedUserId == null) {
      emitLoggedUserNotFoundStatus(emit);
      return;
    }
    final DateTime todayDate = _dateProvider.getNow();
    if (await _areLoggedUserDaysOfReadingNotLoaded(loggedUserId, todayDate)) {
      emit(state.copyWith(
        status: const BlocStatusLoading(),
        todayDate: todayDate,
      ));
    } else {
      emit(state.copyWith(
        todayDate: todayDate,
      ));
    }
    _setDaysListener(loggedUserId, todayDate.month, todayDate.year);
    await Future.delayed(
      const Duration(milliseconds: 300),
    );
    await _loadAllUserBooksUseCase.execute(userId: loggedUserId);
    await _loadLoggedUserDaysFromGivenMonthPreviousAndNext(
      loggedUserId,
      todayDate.month,
      todayDate.year,
    );
  }

  void _daysOfReadingUpdated(
    CalendarEventDaysOfReadingUpdated event,
    Emitter<CalendarState> emit,
  ) {
    emit(state.copyWith(
      daysOfReading: event.daysOfReading,
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
    _setDaysListener(loggedUserId, event.month, event.year);
    await _loadLoggedUserDaysFromGivenMonthPreviousAndNext(
      loggedUserId,
      event.month,
      event.year,
    );
  }

  Future<String?> _getLoggedUserId() async {
    return await _getLoggedUserIdUseCase.execute().first;
  }

  Future<bool> _areLoggedUserDaysOfReadingNotLoaded(
    String loggedUserId,
    DateTime date,
  ) async {
    return await _getLoggedUserDaysFromGivenMonthPreviousAndNext(
          loggedUserId,
          date.month,
          date.year,
        ).first ==
        null;
  }

  void _setDaysListener(String loggedUserId, int month, int year) {
    _daysListener?.cancel();
    _daysListener = _getLoggedUserDaysFromGivenMonthPreviousAndNext(
      loggedUserId,
      month,
      year,
    ).listen(
      (List<Day>? daysOfReading) {
        if (daysOfReading != null) {
          add(CalendarEventDaysOfReadingUpdated(daysOfReading: daysOfReading));
        }
      },
    );
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

  Stream<List<Day>?> _getLoggedUserDaysFromGivenMonthPreviousAndNext(
    String loggedUserId,
    int month,
    int year,
  ) {
    final DateTime previousMonthDate = DateTime(year, month - 1);
    final DateTime nextMonthDate = DateTime(year, month + 1);
    final Stream<List<Day>?> daysFromGivenMonth$ =
        _getUserDaysFromMonthUseCase.execute(
      userId: loggedUserId,
      month: month,
      year: year,
    );
    final Stream<List<Day>?> daysFromPreviousMonth$ =
        _getUserDaysFromMonthUseCase.execute(
      userId: loggedUserId,
      month: previousMonthDate.month,
      year: previousMonthDate.year,
    );
    final Stream<List<Day>?> daysFromNextMonth$ =
        _getUserDaysFromMonthUseCase.execute(
      userId: loggedUserId,
      month: nextMonthDate.month,
      year: nextMonthDate.year,
    );
    return Rx.combineLatest3(
      daysFromPreviousMonth$,
      daysFromGivenMonth$,
      daysFromNextMonth$,
      (
        List<Day>? daysFromPreviousMonth,
        List<Day>? daysFromGivenMonth,
        List<Day>? daysFromNextMonth,
      ) {
        if (daysFromPreviousMonth == null &&
            daysFromGivenMonth == null &&
            daysFromNextMonth == null) {
          return null;
        }
        return [
          ...?daysFromPreviousMonth,
          ...?daysFromGivenMonth,
          ...?daysFromNextMonth,
        ];
      },
    );
  }
}
