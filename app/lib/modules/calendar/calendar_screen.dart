import 'package:app/modules/calendar/calendar_screen_controller.dart';
import 'package:app/modules/calendar/elements/calendar/calendar.dart';
import 'package:app/modules/calendar/elements/day_info/day_info.dart';
import 'package:flutter/material.dart';

class CalendarScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CalendarScreenController controller = CalendarScreenController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 2,
          child: Container(
            padding: EdgeInsets.all(8.0),
            child: Calendar(
              selectedDayId$: controller.selectedDayId$,
              onTapDay: (String dayId) {
                controller.onTapDay(dayId);
              },
            ),
          ),
        ),
        Expanded(
          child: Container(
            child: _DayInfo(dayId$: controller.selectedDayId$),
          ),
        ),
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
