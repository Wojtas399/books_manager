import 'package:app/modules/calendar/elements/calendar.dart';
import 'package:flutter/material.dart';

class CalendarScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 2,
          child: Container(
            padding: EdgeInsets.all(8.0),
            child: Calendar(),
          ),
        ),
        Expanded(
          child: Container(
            child: Text('Description'),
          ),
        ),
      ],
    );
  }
}
