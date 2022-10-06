part of 'calendar_bloc.dart';

class CalendarState extends BlocState {
  final DateTime? todayDate;
  final int? displayingMonth;
  final int? displayingYear;
  final List<Day> userDaysFromMonth;

  const CalendarState({
    required super.status,
    required this.todayDate,
    required this.displayingMonth,
    required this.displayingYear,
    required this.userDaysFromMonth,
  });

  @override
  List<Object> get props => [
        status,
        todayDate ?? '',
        displayingMonth ?? '',
        displayingYear ?? '',
        userDaysFromMonth,
      ];

  @override
  CalendarState copyWith({
    BlocStatus? status,
    DateTime? todayDate,
    int? displayingMonth,
    int? displayingYear,
    List<Day>? userDaysFromMonth,
  }) {
    return CalendarState(
      status: status ?? const BlocStatusComplete(),
      todayDate: todayDate ?? this.todayDate,
      displayingMonth: displayingMonth ?? this.displayingMonth,
      displayingYear: displayingYear ?? this.displayingYear,
      userDaysFromMonth: userDaysFromMonth ?? this.userDaysFromMonth,
    );
  }

  List<List<CalendarDay>> get weeks => _createWeeks();

  List<List<CalendarDay>> _createWeeks() {
    final int? month = displayingMonth;
    final int? year = displayingYear;
    if (month == null || year == null) {
      return [];
    }
    List<List<CalendarDay>> weeks = [];
    DateTime date = DateTime(year, month);
    if (date.weekday > 1) {
      date = date.subtract(Duration(days: date.weekday - 1));
    }
    for (int weekNumber = 1; weekNumber <= 6; weekNumber++) {
      final List<CalendarDay> newWeek = _createDaysFromWeek(date);
      weeks.add(newWeek);
      date = DateTime(date.year, date.month, date.day + 7);
    }
    return weeks;
  }

  List<CalendarDay> _createDaysFromWeek(
    DateTime dateOfFirstDayOfTheWeek,
  ) {
    final List<CalendarDay> daysFromWeek = [];
    final DateTime? todayDate = this.todayDate;
    DateTime date = dateOfFirstDayOfTheWeek;
    for (int weekDayNumber = 1; weekDayNumber <= 7; weekDayNumber++) {
      final CalendarDay newCalendarDay = CalendarDay(
        date: date,
        isDisabled: date.month != displayingMonth,
        isTodayDay: todayDate != null
            ? DateUtils.areDatesTheSame(date1: date, date2: todayDate)
            : false,
        readBooks: userDaysFromMonth.selectDayByDate(date)?.readBooks ?? [],
      );
      daysFromWeek.add(newCalendarDay);
      date = date.add(const Duration(days: 1));
    }
    return daysFromWeek;
  }
}

class CalendarDay extends Equatable {
  final DateTime date;
  final bool isDisabled;
  final bool isTodayDay;
  final List<ReadBook> readBooks;

  const CalendarDay({
    required this.date,
    this.isDisabled = false,
    this.isTodayDay = false,
    this.readBooks = const [],
  });

  @override
  List<Object> get props => [
        date,
        isDisabled,
        isTodayDay,
        readBooks,
      ];
}

CalendarDay createCalendarDay({
  DateTime? date,
  bool isDisabled = false,
  bool isTodayDay = false,
  List<ReadBook> readBooks = const [],
}) {
  return CalendarDay(
    date: date ?? DateTime(2022),
    isDisabled: isDisabled,
    isTodayDay: isTodayDay,
    readBooks: readBooks,
  );
}

extension DaysExtensions on List<Day> {
  Day? selectDayByDate(DateTime date) {
    final List<Day?> days = [...this];
    return days.firstWhere(
      (Day? day) => day != null
          ? DateUtils.areDatesTheSame(date1: day.date, date2: date)
          : false,
      orElse: () => null,
    );
  }
}
