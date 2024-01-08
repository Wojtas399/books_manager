import 'package:app/config/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class CalendarComponentMonthAndYear extends StatelessWidget {
  final int month;
  final int year;
  final VoidCallback onPreviousMonthButtonPressed;
  final VoidCallback onNextMonthButtonPressed;

  const CalendarComponentMonthAndYear({
    super.key,
    required this.month,
    required this.year,
    required this.onPreviousMonthButtonPressed,
    required this.onNextMonthButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _ChangeMonthButton(
            iconData: MdiIcons.chevronLeft,
            onPressed: onPreviousMonthButtonPressed,
          ),
          _MonthAndYear(month: month, year: year),
          _ChangeMonthButton(
            iconData: MdiIcons.chevronRight,
            onPressed: onNextMonthButtonPressed,
          ),
        ],
      ),
    );
  }
}

class _ChangeMonthButton extends StatelessWidget {
  final IconData iconData;
  final VoidCallback onPressed;

  const _ChangeMonthButton({
    required this.iconData,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      splashRadius: 16,
      icon: Icon(iconData),
    );
  }
}

class _MonthAndYear extends StatelessWidget {
  final int month;
  final int year;

  const _MonthAndYear({
    required this.month,
    required this.year,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _Text(text: _getMonthName(month)),
        const SizedBox(width: 8),
        _Text(text: '$year'),
      ],
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

class _Text extends StatelessWidget {
  final String text;

  const _Text({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppColors.primary,
          ),
    );
  }
}
