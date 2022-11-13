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
    List<Day>? daysOfReading,
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
    final DateTime todayDate = _dateProvider.getNow();
    emit(state.copyWith(
      status: const BlocStatusLoading(),
      todayDate: todayDate,
    ));
    _setDaysListener(todayDate.month, todayDate.year, emit);
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
    _daysListener?.cancel();
    _daysListener = null;
    _setDaysListener(event.month, event.year, emit);
  }

  void _setDaysListener(int month, int year, Emitter<CalendarState> emit) {
    _daysListener = _getLoggedUserIdUseCase
        .execute()
        .switchMap(
          (String? loggedUserId) => _getDays(loggedUserId, month, year),
        )
        .listen(
          (List<Day>? days) => add(
            CalendarEventDaysOfReadingUpdated(daysOfReading: days),
          ),
        );
  }

  Stream<List<Day>?> _getDays(String? loggedUserId, int month, int year) {
    if (loggedUserId == null) {
      return Stream.value(null);
    }
    return Rx.combineLatest3(
      _getLoggedUserDaysFromPreviousMonth(loggedUserId, month, year),
      _getLoggedUserDaysFromMonth(loggedUserId, month, year),
      _getLoggedUserDaysFromNextMonth(loggedUserId, month, year),
      _combineDaysFrom3Months,
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
