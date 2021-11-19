import 'package:app/modules/calendar/elements/calendar_body.dart';
import 'package:app/modules/calendar/elements/calendar_controller.dart';
import 'package:app/modules/calendar/elements/calendar_header.dart';
import 'package:flutter/material.dart';

class Calendar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CalendarController controller = CalendarController();

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
              child: _CalendarBody(days$: controller.days$),
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

  const _CalendarBody({required this.days$});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: days$,
      builder: (_, AsyncSnapshot<List<List<CalendarDay>>> snapshot) {
        List<List<CalendarDay>>? days = snapshot.data;
        if (days != null) {
          return CalendarBody(weeks: days);
        }
        return SizedBox(height: 0);
      },
    );
  }
}
