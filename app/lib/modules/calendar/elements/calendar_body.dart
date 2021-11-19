import 'package:app/constants/theme.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'calendar_controller.dart';

class CalendarBody extends StatelessWidget {
  final List<List<CalendarDay>> weeks;

  const CalendarBody({required this.weeks});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 8.0, bottom: 2.0, left: 8.0, right: 8.0),
      child: Column(
        children: [
          Expanded(
            child: _DaysShortcuts(),
          ),
          Expanded(
            flex: 11,
            child: _Weeks(weeks: weeks),
          ),
        ],
      ),
    );
  }
}

class _DaysShortcuts extends StatelessWidget {
  const _DaysShortcuts();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: HexColor(AppColors.DARK_GREEN2),
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _DayShortcut(text: 'Pon'),
          _DayShortcut(text: 'Wto'),
          _DayShortcut(text: 'Śro'),
          _DayShortcut(text: 'Czw'),
          _DayShortcut(text: 'Pią'),
          _DayShortcut(text: 'Sob'),
          _DayShortcut(text: 'Nie')
        ],
      ),
    );
  }
}

class _Weeks extends StatelessWidget {
  final List<List<CalendarDay>> weeks;

  const _Weeks({required this.weeks});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: weeks.map((days) {
        int weekIndex = weeks.indexOf(days);
        return _Week(days: days, isTheLastWeek: weekIndex == 5);
      }).toList(),
    );
  }
}

class _DayShortcut extends StatelessWidget {
  final String text;

  const _DayShortcut({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      child: Center(
        child: Text(text, style: Theme.of(context).textTheme.subtitle2),
      ),
    );
  }
}

class _Week extends StatelessWidget {
  final List<CalendarDay> days;
  final bool isTheLastWeek;

  const _Week({required this.days, this.isTheLastWeek = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: days.map((day) {
        return _DayItem(
          dayNumber: day.dayNumber,
          isTheLastRow: isTheLastWeek,
          isDisabled: day.isDisabled,
        );
      }).toList(),
    );
  }
}

class _DayItem extends StatelessWidget {
  final int dayNumber;
  final bool isTheLastRow;
  final bool isDisabled;

  const _DayItem({
    required this.dayNumber,
    this.isTheLastRow = false,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      padding: EdgeInsets.all(4.0),
      margin: isTheLastRow
          ? EdgeInsets.only(left: 3.0, top: 3.0, right: 3.0)
          : EdgeInsets.all(3.0),
      decoration: BoxDecoration(
        color: HexColor(isDisabled ? '#D0EFE6' : AppColors.LIGHT_GREEN),
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Text(
        '$dayNumber',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyText1,
      ),
    );
  }
}
