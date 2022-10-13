import 'package:app/components/calendar_component/calendar_component_body.dart';
import 'package:app/components/calendar_component/calendar_component_days_shortcuts.dart';
import 'package:app/components/calendar_component/calendar_component_month_and_year.dart';
import 'package:app/providers/date_provider.dart';
import 'package:app/utils/date_utils.dart';
import 'package:flutter/widgets.dart';

class CalendarComponent extends StatefulWidget {
  final DateTime initialDate;
  final List<DateTime> markedDays;
  final Function(DateTime date)? onDayPressed;
  final Function(int month, int year)? onMonthChanged;

  const CalendarComponent({
    super.key,
    required this.initialDate,
    this.markedDays = const [],
    this.onDayPressed,
    this.onMonthChanged,
  });

  @override
  State<CalendarComponent> createState() => _CalendarComponentState();
}

class _CalendarComponentState extends State<CalendarComponent> {
  final DateProvider _dateProvider = DateProvider();
  late int _displayingMonth;
  late int _displayingYear;

  @override
  void initState() {
    super.initState();
    _displayingMonth = widget.initialDate.month;
    _displayingYear = widget.initialDate.year;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CalendarComponentMonthAndYear(
          month: _displayingMonth,
          year: _displayingYear,
          onPreviousMonthButtonPressed: _previousMonth,
          onNextMonthButtonPressed: _nextMonth,
        ),
        const CalendarComponentDaysShortcuts(),
        Expanded(
          child: CalendarComponentBody(
            weeks: _createWeeks(),
            onDayPressed: widget.onDayPressed,
          ),
        ),
      ],
    );
  }

  void _previousMonth() {
    final DateTime dateOfFirstDayInPreviousMonth =
        _dateProvider.getDateOfFirstDayInPreviousMonth(
      month: _displayingMonth,
      year: _displayingYear,
    );
    setState(() {
      _displayingMonth = dateOfFirstDayInPreviousMonth.month;
      _displayingYear = dateOfFirstDayInPreviousMonth.year;
    });
    _emitMonthChange();
  }

  void _nextMonth() {
    final DateTime dateOfFirstDayInNextMonth =
        _dateProvider.getDateOfFirstDayInNextMonth(
      month: _displayingMonth,
      year: _displayingYear,
    );
    setState(() {
      _displayingMonth = dateOfFirstDayInNextMonth.month;
      _displayingYear = dateOfFirstDayInNextMonth.year;
    });
    _emitMonthChange();
  }

  List<List<CalendarComponentDay>> _createWeeks() {
    List<List<CalendarComponentDay>> weeks = [];
    DateTime date = DateTime(_displayingYear, _displayingMonth);
    if (date.weekday > 1) {
      date = date.subtract(Duration(days: date.weekday - 1));
    }
    for (int weekNumber = 1; weekNumber <= 6; weekNumber++) {
      final List<CalendarComponentDay> newWeek = _createDaysFromWeek(date);
      weeks.add(newWeek);
      date = DateTime(date.year, date.month, date.day + 7);
    }
    return weeks;
  }

  List<CalendarComponentDay> _createDaysFromWeek(
    DateTime dateOfFirstDayOfTheWeek,
  ) {
    final List<CalendarComponentDay> daysFromWeek = [];
    final DateTime todayDate = _dateProvider.getNow();
    DateTime date = dateOfFirstDayOfTheWeek;
    for (int weekDayNumber = 1; weekDayNumber <= 7; weekDayNumber++) {
      final CalendarComponentDay newCalendarDay = CalendarComponentDay(
          date: date,
          isDisabled: date.month != _displayingMonth,
          isTodayDay: DateUtils.areDatesTheSame(date1: date, date2: todayDate),
          isMarked: widget.markedDays.contains(date));
      daysFromWeek.add(newCalendarDay);
      date = date.add(const Duration(days: 1));
    }
    return daysFromWeek;
  }

  void _emitMonthChange() {
    final Function(int month, int year)? onMonthChanged = widget.onMonthChanged;
    if (onMonthChanged != null) {
      onMonthChanged(_displayingMonth, _displayingYear);
    }
  }
}

class CalendarComponentDay {
  final DateTime date;
  final bool isDisabled;
  final bool isTodayDay;
  final bool isMarked;

  const CalendarComponentDay({
    required this.date,
    required this.isDisabled,
    required this.isTodayDay,
    this.isMarked = false,
  });
}
