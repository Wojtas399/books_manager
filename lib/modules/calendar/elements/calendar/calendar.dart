import 'package:app/core/day/day_query.dart';
import 'package:app/modules/calendar/elements/calendar/calendar_body.dart';
import 'package:app/modules/calendar/elements/calendar/calendar_controller.dart';
import 'package:app/modules/calendar/elements/calendar/calendar_header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Calendar extends StatelessWidget {
  final Stream<String> selectedDayId$;
  final Function(String dayId) onTapDay;

  const Calendar({required this.selectedDayId$, required this.onTapDay});

  @override
  Widget build(BuildContext context) {
    CalendarController controller = CalendarController(
      selectedDayId$: selectedDayId$,
      dayQuery: Provider.of<DayQuery>(context),
    );

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          color: Colors.white,
        ),
        child: Column(
          children: [
            Expanded(
              child: _CalendarHeader(
                header$: controller.header$,
                onChangeBack: () => controller.changeToThePreviousMonth(),
                onChangeForward: () => controller.changeToTheNextMonth(),
              ),
            ),
            Expanded(
              flex: 7,
              child: _CalendarBody(
                days$: controller.days$,
                onTapDay: onTapDay,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CalendarHeader extends StatelessWidget {
  final Stream<String> header$;
  final Function onChangeBack;
  final Function onChangeForward;

  const _CalendarHeader({
    required this.header$,
    required this.onChangeBack,
    required this.onChangeForward,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: header$,
      builder: (_, AsyncSnapshot<String> snapshot) {
        String? header = snapshot.data;
        if (header != null) {
          return CalendarHeader(
            header: header,
            onChangeBack: onChangeBack,
            onChangeForward: onChangeForward,
          );
        }
        return SizedBox(height: 0);
      },
    );
  }
}

class _CalendarBody extends StatelessWidget {
  final Stream<List<List<CalendarDay>>> days$;
  final Function(String dayId) onTapDay;

  const _CalendarBody({required this.days$, required this.onTapDay});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: days$,
      builder: (_, AsyncSnapshot<List<List<CalendarDay>>> snapshot) {
        List<List<CalendarDay>>? days = snapshot.data;
        if (days != null) {
          return CalendarBody(
            weeks: days,
            onTapDay: onTapDay,
          );
        }
        return SizedBox(height: 0);
      },
    );
  }
}
