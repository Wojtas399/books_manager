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

  CalendarBloc({
    required DateProvider dateProvider,
    BlocStatus status = const BlocStatusInitial(),
    DateTime? todayDate,
    int? displayingMonth,
    int? displayingYear,
  }) : super(
          CalendarState(
            status: status,
            todayDate: todayDate,
            displayingMonth: displayingMonth,
            displayingYear: displayingYear,
          ),
        ) {
    _dateProvider = dateProvider;
    on<CalendarEventInitialize>(_initialize);
    on<CalendarEventPreviousMonth>(_previousMonth);
    on<CalendarEventNextMonth>(_nextMonth);
  }

  void _initialize(
    CalendarEventInitialize event,
    Emitter<CalendarState> emit,
  ) {
    final DateTime todayDate = _dateProvider.getNow();
    emit(state.copyWith(
      todayDate: todayDate,
      displayingMonth: todayDate.month,
      displayingYear: todayDate.year,
    ));
  }

  void _previousMonth(
    CalendarEventPreviousMonth event,
    Emitter<CalendarState> emit,
  ) {
    final int? displayingMonth = state.displayingMonth;
    final int? displayingYear = state.displayingYear;
    if (displayingMonth != null && displayingYear != null) {
      final DateTime date = DateTime(displayingYear, displayingMonth).subtract(
        const Duration(days: 1),
      );
      emit(state.copyWith(
        displayingMonth: date.month,
        displayingYear: date.year,
      ));
    }
  }

  void _nextMonth(
    CalendarEventNextMonth event,
    Emitter<CalendarState> emit,
  ) {
    final int? displayingMonth = state.displayingMonth;
    final int? displayingYear = state.displayingYear;
    if (displayingMonth != null && displayingYear != null) {
      final int daysInMonth = DateUtils.getDaysInMonth(
        month: displayingMonth,
        year: displayingYear,
      );
      final DateTime date = DateTime(displayingYear, displayingMonth).add(
        Duration(days: daysInMonth + 1),
      );
      emit(state.copyWith(
        displayingMonth: date.month,
        displayingYear: date.year,
      ));
    }
  }
}
