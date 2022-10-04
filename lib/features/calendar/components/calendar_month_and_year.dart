import 'package:app/config/themes/app_colors.dart';
import 'package:app/features/calendar/bloc/calendar_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class CalendarMonthAndYear extends StatelessWidget {
  const CalendarMonthAndYear({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          _PreviousMonthButton(),
          _MonthAndYear(),
          _NextMonthButton(),
        ],
      ),
    );
  }
}

class _PreviousMonthButton extends StatelessWidget {
  const _PreviousMonthButton();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => _onPreviousMonthButtonPressed(context),
      splashRadius: 16,
      icon: const Icon(MdiIcons.chevronLeft),
    );
  }

  void _onPreviousMonthButtonPressed(BuildContext context) {
    context.read<CalendarBloc>().add(
          const CalendarEventPreviousMonth(),
        );
  }
}

class _NextMonthButton extends StatelessWidget {
  const _NextMonthButton();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => _onNextMonthButtonPressed(context),
      splashRadius: 16,
      icon: const Icon(MdiIcons.chevronRight),
    );
  }

  void _onNextMonthButtonPressed(BuildContext context) {
    context.read<CalendarBloc>().add(
          const CalendarEventNextMonth(),
        );
  }
}

class _MonthAndYear extends StatelessWidget {
  const _MonthAndYear();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        _Month(),
        SizedBox(width: 8),
        _Year(),
      ],
    );
  }
}

class _Month extends StatelessWidget {
  const _Month();

  @override
  Widget build(BuildContext context) {
    final int? month = context.select(
      (CalendarBloc bloc) => bloc.state.displayingMonth,
    );
    return Text(
      month != null ? _getMonthName(month) : '',
      style: Theme.of(context).textTheme.headline6?.copyWith(
            color: AppColors.primary,
          ),
    );
  }

  String _getMonthName(int monthNumber) {
    final List<String> monthsNames = [
      'Styczeń',
      'Luty',
      'Marzec',
      'Kwiecień',
      'Maj',
      'Czerwiec',
      'Lipiec',
      'Sierpnień',
      'Wrzesień',
      'Październik',
      'Listopad',
      'Grudzień'
    ];
    return monthsNames[monthNumber - 1];
  }
}

class _Year extends StatelessWidget {
  const _Year();

  @override
  Widget build(BuildContext context) {
    final int? year = context.select(
      (CalendarBloc bloc) => bloc.state.displayingYear,
    );
    return Text(
      '$year',
      style: Theme.of(context).textTheme.headline6?.copyWith(
            color: AppColors.primary,
          ),
    );
  }
}
