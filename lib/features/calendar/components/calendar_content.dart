import 'package:app/features/calendar/components/calendar_body.dart';
import 'package:app/features/calendar/components/calendar_days_shortcuts.dart';
import 'package:app/features/calendar/components/calendar_month_and_year.dart';
import 'package:flutter/material.dart';

class CalendarContent extends StatelessWidget {
  const CalendarContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        children: const [
          CalendarMonthAndYear(),
          CalendarDaysShortcuts(),
          Expanded(
            child: CalendarBody(),
          ),
        ],
      ),
    );
  }
}
