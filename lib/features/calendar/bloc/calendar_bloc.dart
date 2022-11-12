import 'dart:async';

import 'package:app/domain/entities/day.dart';
import 'package:app/domain/entities/read_book.dart';
import 'package:app/domain/use_cases/auth/get_logged_user_id_use_case.dart';
import 'package:app/domain/use_cases/day/get_user_days_from_month_use_case.dart';
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
  late final GetUserDaysFromMonthUseCase _getUserDaysFromMonthUseCase;
  StreamSubscription<List<Day>?>? _daysListener;

  CalendarBloc({
    required DateProvider dateProvider,
    required GetLoggedUserIdUseCase getLoggedUserIdUseCase,
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
    _getUserDaysFromMonthUseCase = getUserDaysFromMonthUseCase;
    on<CalendarEventInitialize>(_initialize);
    on<CalendarEventDaysOfReadingUpdated>(_daysOfReadingUpdated);
    on<CalendarEventMonthChanged>(_monthChanged);
  }

  @override
  Future<void> close() {
    _daysListener?.cancel();
    return super.close();
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
    emit(state.copyWith(
      todayDate: todayDate,
    ));
    _setDaysListener(loggedUserId, todayDate.month, todayDate.year);
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
    emitLoadingStatus(emit);
    final String? loggedUserId = await _getLoggedUserId();
    if (loggedUserId == null) {
      emitLoggedUserNotFoundStatus(emit);
      return;
    }
    _setDaysListener(loggedUserId, event.month, event.year);
  }

  Future<String?> _getLoggedUserId() async {
    return await _getLoggedUserIdUseCase.execute().first;
  }

  void _setDaysListener(String loggedUserId, int month, int year) {
    _daysListener?.cancel();
    _daysListener = Rx.combineLatest3(
      _getLoggedUserDaysFromPreviousMonth(loggedUserId, month, year),
      _getLoggedUserDaysFromMonth(loggedUserId, month, year),
      _getLoggedUserDaysFromNextMonth(loggedUserId, month, year),
      _combineDaysFrom3Months,
    ).listen(
      (List<Day> daysOfReading) {
        add(
          CalendarEventDaysOfReadingUpdated(daysOfReading: daysOfReading),
        );
      },
    );
  }

  Stream<List<Day>> _getLoggedUserDaysFromMonth(
    String loggedUserId,
    int month,
    int year,
  ) {
    return _getUserDaysFromMonthUseCase.execute(
      userId: loggedUserId,
      month: month,
      year: year,
    );
  }

  Stream<List<Day>> _getLoggedUserDaysFromPreviousMonth(
    String loggedUserId,
    int month,
    int year,
  ) {
    final DateTime previousMonthDate = DateTime(year, month - 1);
    return _getUserDaysFromMonthUseCase.execute(
      userId: loggedUserId,
      month: previousMonthDate.month,
      year: previousMonthDate.year,
    );
  }

  Stream<List<Day>> _getLoggedUserDaysFromNextMonth(
    String loggedUserId,
    int month,
    int year,
  ) {
    final DateTime nextMonthDate = DateTime(year, month + 1);
    return _getUserDaysFromMonthUseCase.execute(
      userId: loggedUserId,
      month: nextMonthDate.month,
      year: nextMonthDate.year,
    );
  }

  List<Day> _combineDaysFrom3Months(
    List<Day> daysFromFirstMonth,
    List<Day> daysFromSecondMonth,
    List<Day> daysFromThirdMonth,
  ) {
    return [
      ...daysFromFirstMonth,
      ...daysFromSecondMonth,
      ...daysFromThirdMonth,
    ];
  }
}
