import 'package:app/modules/calendar/calendar_screen_controller.dart';
import 'package:app/modules/calendar/elements/calendar/calendar.dart';
import 'package:app/modules/calendar/elements/day_info/day_info.dart';
import 'package:flutter/material.dart';

class CalendarScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CalendarScreenController controller = CalendarScreenController();

    return Stack(
      children: [
        Container(
          height: 430,
          padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 16.0),
          child: Calendar(
            selectedDayId$: controller.selectedDayId$,
            onTapDay: (String dayId) {
              controller.onTapDay(dayId);
            },
          ),
        ),
        _DayInfo(dayId$: controller.selectedDayId$),
      ],
    );
  }
}

class _DayInfo extends StatelessWidget {
  final Stream<String> dayId$;

  const _DayInfo({required this.dayId$});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: dayId$,
      builder: (_, AsyncSnapshot<String> snapshot) {
        String? dayId = snapshot.data;
        if (dayId != null) {
          return DayInfo(dayId: dayId);
        }
        return SizedBox(height: 0);
      },
    );
  }
}
