import 'package:flutter/material.dart';

class CalendarBody extends StatelessWidget {
  const CalendarBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 10, right: 10, bottom: 96),
      child: _Month(
        weeks: [
          [
            _DayArgs(number: 26, isDisabled: true),
            _DayArgs(number: 27, isDisabled: true),
            _DayArgs(number: 28, isDisabled: true),
            _DayArgs(number: 29, isDisabled: true),
            _DayArgs(number: 30, isDisabled: true),
            _DayArgs(number: 1),
            _DayArgs(number: 2),
          ],
          [
            _DayArgs(number: 3),
            _DayArgs(number: 4),
            _DayArgs(number: 5),
            _DayArgs(number: 6),
            _DayArgs(number: 7),
            _DayArgs(number: 8),
            _DayArgs(number: 9),
          ],
          [
            _DayArgs(number: 10),
            _DayArgs(number: 11),
            _DayArgs(number: 12),
            _DayArgs(number: 13),
            _DayArgs(number: 14),
            _DayArgs(number: 15),
            _DayArgs(number: 16),
          ],
          [
            _DayArgs(number: 17),
            _DayArgs(number: 18),
            _DayArgs(number: 19),
            _DayArgs(number: 20),
            _DayArgs(number: 21),
            _DayArgs(number: 22),
            _DayArgs(number: 23),
          ],
          [
            _DayArgs(number: 24),
            _DayArgs(number: 25),
            _DayArgs(number: 26),
            _DayArgs(number: 27),
            _DayArgs(number: 28),
            _DayArgs(number: 29),
            _DayArgs(number: 30),
          ],
          [
            _DayArgs(number: 31),
            _DayArgs(number: 1, isDisabled: true),
            _DayArgs(number: 2, isDisabled: true),
            _DayArgs(number: 3, isDisabled: true),
            _DayArgs(number: 4, isDisabled: true),
            _DayArgs(number: 5, isDisabled: true),
            _DayArgs(number: 6, isDisabled: true),
          ]
        ],
      ),
    );
  }
}

class _Month extends StatelessWidget {
  final List<List<_DayArgs>> weeks;

  const _Month({required this.weeks});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: weeks.map((List<_DayArgs> days) => _Week(days: days)).toList(),
    );
  }
}

class _Week extends StatelessWidget {
  final List<_DayArgs> days;

  const _Week({required this.days});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: days.map((_DayArgs args) => _Day(args: args)).toList(),
      ),
    );
  }
}

class _Day extends StatelessWidget {
  final _DayArgs args;

  const _Day({
    required this.args,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Opacity(
        opacity: args.isDisabled ? 0.30 : 1,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${args.number}'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DayArgs {
  final int number;
  final bool isDisabled;

  const _DayArgs({
    required this.number,
    this.isDisabled = false,
  });
}
