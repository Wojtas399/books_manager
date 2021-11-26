import 'package:app/core/day/day_model.dart';
import 'package:app/core/day/day_query.dart';
import 'package:app/core/services/date_service.dart';
import 'package:rxdart/rxdart.dart';

class CalendarController {
  late Stream<String> _selectedDayId$;
  late DayQuery _dayQuery;
  BehaviorSubject<DateTime> _date =
      new BehaviorSubject<DateTime>.seeded(new DateTime.now());

  CalendarController({
    required Stream<String> selectedDayId$,
    required DayQuery dayQuery,
  }) {
    _selectedDayId$ = selectedDayId$;
    _dayQuery = dayQuery;
  }

  Stream<DateTime> get _date$ => _date.stream;

  Stream<List<String>> get _days$ => _date$.map((date) => _generateMonthDays(
        date,
        _countTheDifferenceBetweenFirstAndPassedWeekFromTheMonth(date),
      ));

  Stream<List<Day>> get _daysFromDb$ =>
      _date$.flatMap((date) => _dayQuery.selectDaysFromTheMonth(date.month));

  Stream<List<List<CalendarDay>>> get days$ => Rx.combineLatest4(
        _date$,
        _days$,
        _daysFromDb$,
        _selectedDayId$,
        (
          DateTime date,
          List<String> days,
          List<Day> daysFromDb,
          String selectedDayId,
        ) =>
            _generateMonthDaysAsCalendarItems(
          date,
          days,
          daysFromDb,
          selectedDayId,
        ),
      );

  Stream<String> get header$ => _date$.map(
        (date) => '${DateService.getMonthName(date.month - 1)} ${date.year}',
      );

  void changeToThePreviousMonth() {
    DateTime currentDate = _date.value;
    _date.add(new DateTime(
      currentDate.year,
      currentDate.month - 1,
      currentDate.day,
    ));
  }

  void changeToTheNextMonth() {
    DateTime currentDate = _date.value;
    _date.add(new DateTime(
      currentDate.year,
      currentDate.month + 1,
      currentDate.day,
    ));
  }

  int _countTheDifferenceBetweenFirstAndPassedWeekFromTheMonth(DateTime date) {
    int weekDifference = 0;
    bool isTheFirstWeekFounded = false;
    while (!isTheFirstWeekFounded) {
      DateTime newDate =
          new DateTime(date.year, date.month, date.day + (7 * weekDifference));
      List<String> weekDays = DateService.getWeekDays(newDate);
      List<String> dateInArray = weekDays[0].split('.');
      int day = int.parse(dateInArray[0]);
      int month = int.parse(dateInArray[1]);
      int year = int.parse(dateInArray[2]);
      if (day == 1 || month < date.month || year < date.year) {
        isTheFirstWeekFounded = true;
      } else {
        weekDifference--;
      }
    }
    return weekDifference;
  }

  List<String> _generateMonthDays(DateTime date, int weekDifference) {
    List<String> days = [];
    for (int i = 0; i < 6; i++) {
      DateTime newDate =
          new DateTime(date.year, date.month, date.day + (7 * weekDifference));
      List<String> weekDays = DateService.getWeekDays(newDate);
      for (String day in weekDays) {
        days.add(day);
      }
      weekDifference++;
    }
    return days;
  }

  List<List<CalendarDay>> _generateMonthDaysAsCalendarItems(
    DateTime date,
    List<String> days,
    List<Day> daysFromDb,
    String selectedDayId,
  ) {
    int dayIndex = -1;
    List<String> daysIdsFromDb = daysFromDb.map((day) => day.id).toList();
    return List.generate(
      6,
      (i) => List.generate(
        7,
        (j) {
          dayIndex++;
          List<String> dayInArray = days[dayIndex].split('.');
          int day = int.parse(dayInArray[0]);
          int month = int.parse(dayInArray[1]);
          return CalendarDay(
            id: days[dayIndex],
            dayNumber: day,
            hasReadBooks: daysIdsFromDb.contains(days[dayIndex]),
            isDisabled: month != date.month,
            isSelected: days[dayIndex] == selectedDayId,
          );
        },
      ),
    );
  }
}

class CalendarDay {
  final String id;
  final int dayNumber;
  final bool hasReadBooks;
  final bool isDisabled;
  final bool isSelected;

  CalendarDay({
    required this.id,
    required this.dayNumber,
    required this.hasReadBooks,
    required this.isDisabled,
    required this.isSelected,
  });
}
