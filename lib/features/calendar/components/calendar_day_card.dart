import 'package:app/config/navigation.dart';
import 'package:app/config/themes/app_colors.dart';
import 'package:app/features/calendar/bloc/calendar_bloc.dart';
import 'package:app/features/day_preview/day_preview_screen.dart';
import 'package:flutter/material.dart';

class CalendarDayCard extends StatelessWidget {
  final CalendarDay day;

  const CalendarDayCard({
    super.key,
    required this.day,
  });

  @override
  Widget build(BuildContext context) {
    return _Card(
      onPressed: _onDayPressed,
      isDayDisabled: day.isDisabled,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _DayNumber(
            number: day.date.day,
            isMarkedAsTodayDay: day.isTodayDay,
          ),
          day.readBooks.isNotEmpty ? const _ReadBooksMark() : const SizedBox(),
        ],
      ),
    );
  }

  void _onDayPressed() {
    Navigation.navigateToDayPreview(
      dayPreviewScreenArguments: DayPreviewScreenArguments(
        date: day.date,
        readBooks: day.readBooks,
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final bool isDayDisabled;
  final VoidCallback? onPressed;
  final Widget child;

  const _Card({
    this.isDayDisabled = false,
    this.onPressed,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Opacity(
        opacity: isDayDisabled ? 0.30 : 1,
        child: GestureDetector(
          onTap: isDayDisabled ? null : onPressed,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                top: 4,
                bottom: 12,
                left: 4,
                right: 4,
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

class _DayNumber extends StatelessWidget {
  final int number;
  final bool isMarkedAsTodayDay;

  const _DayNumber({
    required this.number,
    this.isMarkedAsTodayDay = false,
  });

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: isMarkedAsTodayDay ? AppColors.primary : null,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Center(
          child: Text(
            '$number',
            style: TextStyle(
              color: isMarkedAsTodayDay ? Colors.white : null,
            ),
          ),
        ),
      ),
    );
  }
}

class _ReadBooksMark extends StatelessWidget {
  const _ReadBooksMark();

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Container(
        width: 12,
        height: 12,
        color: Colors.orange,
      ),
    );
  }
}
