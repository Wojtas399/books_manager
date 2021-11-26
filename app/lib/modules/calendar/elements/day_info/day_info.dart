import 'package:flutter/material.dart';

class DayInfo extends StatelessWidget {
  final String dayId;

  const DayInfo({required this.dayId});

  @override
  Widget build(BuildContext context) {
    return Text('Day id: $dayId');
  }
}
