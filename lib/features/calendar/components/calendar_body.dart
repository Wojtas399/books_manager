import 'package:app/features/calendar/bloc/calendar_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CalendarBody extends StatelessWidget {
  const CalendarBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 10, right: 10, bottom: 96),
      child: _Month(),
    );
  }
}

class _Month extends StatelessWidget {
  const _Month();

  @override
  Widget build(BuildContext context) {
    final List<List<CalendarDay>> weeks = context.select(
      (CalendarBloc bloc) => bloc.state.weeks,
    );
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: weeks
          .map((List<CalendarDay> daysOfWeek) => _Week(days: daysOfWeek))
          .toList(),
    );
  }
}

class _Week extends StatelessWidget {
  final List<CalendarDay> days;

  const _Week({required this.days});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: days.map((CalendarDay day) => _Day(day: day)).toList(),
      ),
    );
  }
}

class _Day extends StatelessWidget {
  final CalendarDay day;

  const _Day({
    required this.day,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Opacity(
        opacity: day.isDisabled ? 0.30 : 1,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${day.number}'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
