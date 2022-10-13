import 'package:app/components/animated_opacity_and_scale_component.dart';
import 'package:app/components/calendar_component/calendar_component.dart';
import 'package:app/config/navigation.dart';
import 'package:app/domain/entities/read_book.dart';
import 'package:app/features/calendar/bloc/calendar_bloc.dart';
import 'package:app/features/day_preview/day_preview_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CalendarContent extends StatelessWidget {
  const CalendarContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 16),
      child: AnimatedOpacityAndScaleComponent(
        child: _CalendarComponent(),
      ),
    );
  }
}

class _CalendarComponent extends StatelessWidget {
  const _CalendarComponent();

  @override
  Widget build(BuildContext context) {
    final DateTime? initialDate = context.select(
      (CalendarBloc bloc) => bloc.state.todayDate,
    );
    final List<DateTime> markedDates = context.select(
      (CalendarBloc bloc) => bloc.state.datesOfDaysOfReading,
    );

    if (initialDate == null) {
      return const SizedBox();
    }
    return CalendarComponent(
      initialDate: initialDate,
      markedDays: markedDates,
      onMonthChanged: (int month, int year) =>
          _onMonthChanged(month, year, context),
      onDayPressed: (DateTime date) => _onDatePressed(date, context),
    );
  }

  void _onMonthChanged(int month, int year, BuildContext context) {
    context.read<CalendarBloc>().add(
          CalendarEventMonthChanged(month: month, year: year),
        );
  }

  void _onDatePressed(DateTime date, BuildContext context) {
    final List<ReadBook> readBooks =
        context.read<CalendarBloc>().state.getReadBooksFromDay(date);
    Navigation.navigateToDayPreview(
      dayPreviewScreenArguments: DayPreviewScreenArguments(
        date: date,
        readBooks: readBooks,
      ),
    );
  }
}
