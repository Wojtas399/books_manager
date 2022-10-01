import 'package:app/config/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class CalendarMonthAndYear extends StatelessWidget {
  const CalendarMonthAndYear({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {},
            splashRadius: 16,
            icon: const Icon(MdiIcons.chevronLeft),
          ),
          Text(
            'Październik 2022',
            style: Theme.of(context).textTheme.headline6?.copyWith(
                  color: AppColors.primary,
                ),
          ),
          IconButton(
            onPressed: () {},
            splashRadius: 16,
            icon: const Icon(MdiIcons.chevronRight),
          ),
        ],
      ),
    );
  }
}
