part of 'calendar_bloc.dart';

class CalendarState extends BlocState {
  final DateTime? todayDate;
  final int? displayingMonth;
  final int? displayingYear;

  const CalendarState({
    required super.status,
    required this.todayDate,
    required this.displayingMonth,
    required this.displayingYear,
  });

  @override
  List<Object> get props => [
        status,
        todayDate ?? '',
        displayingMonth ?? '',
        displayingYear ?? '',
      ];

  List<List<CalendarDay>> get weeks => _createWeeks();

  CalendarState copyWith({
    BlocStatus? status,
    DateTime? todayDate,
    int? displayingMonth,
    int? displayingYear,
  }) {
    return CalendarState(
      status: status ?? const BlocStatusComplete(),
      todayDate: todayDate ?? this.todayDate,
      displayingMonth: displayingMonth ?? this.displayingMonth,
      displayingYear: displayingYear ?? this.displayingYear,
    );
  }

  List<List<CalendarDay>> _createWeeks() {
    final int? month = displayingMonth;
    final int? year = displayingYear;
    if (month == null || year == null) {
      return [];
    }
    List<List<CalendarDay>> weeks = [];
    DateTime date = DateTime(year, month);
    if (date.weekday > 1) {
      date = date.subtract(Duration(days: date.weekday - 2));
    }
    for (int weekNumber = 1; weekNumber <= 6; weekNumber++) {
      final List<CalendarDay> newWeek = _createDaysFromWeek(date);
      weeks.add(newWeek);
      date = date.add(const Duration(days: 7));
    }
    return weeks;
  }

  List<CalendarDay> _createDaysFromWeek(
    DateTime dateOfFirstDayOfTheWeek,
  ) {
    final List<CalendarDay> daysFromWeek = [];
    DateTime date = dateOfFirstDayOfTheWeek;
    for (int weekDayNumber = 1; weekDayNumber <= 7; weekDayNumber++) {
      final CalendarDay newCalendarDay = CalendarDay(
        number: date.day,
        isDisabled: date.month != displayingMonth,
      );
      daysFromWeek.add(newCalendarDay);
      date = date.add(const Duration(days: 1));
    }
    return daysFromWeek;
  }
}

class CalendarDay extends Equatable {
  final int number;
  final bool isDisabled;

  const CalendarDay({
    required this.number,
    this.isDisabled = false,
  });

  @override
  List<Object> get props => [
        number,
        isDisabled,
      ];
}

CalendarDay createCalendarDay({
  int number = 1,
  bool isDisabled = false,
}) {
  return CalendarDay(
    number: number,
    isDisabled: isDisabled,
  );
}
