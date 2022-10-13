import 'package:app/components/calendar_component/calendar_component.dart';
import 'package:app/components/calendar_component/calendar_component_day_card.dart';
import 'package:flutter/material.dart';

class CalendarComponentBody extends StatelessWidget {
  final List<List<CalendarComponentDay>> weeks;
  final Function(DateTime date)? onDayPressed;

  const CalendarComponentBody({
    super.key,
    required this.weeks,
    this.onDayPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 96),
      child: _Month(
        weeks: weeks,
        onDayPressed: onDayPressed,
      ),
    );
  }
}

class _Month extends StatelessWidget {
  final List<List<CalendarComponentDay>> weeks;
  final Function(DateTime date)? onDayPressed;

  const _Month({required this.weeks, this.onDayPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: weeks
          .map(
            (List<CalendarComponentDay> daysOfWeek) => _Week(
              days: daysOfWeek,
              onDayPressed: onDayPressed,
            ),
          )
          .toList(),
    );
  }
}

class _Week extends StatelessWidget {
  final List<CalendarComponentDay> days;
  final Function(DateTime date)? onDayPressed;

  const _Week({required this.days, this.onDayPressed});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: days
            .map(
              (CalendarComponentDay day) => CalendarComponentDayCard(
                day: day,
                onDayPressed: onDayPressed,
              ),
            )
            .toList(),
      ),
    );
  }
}
