import 'package:app/config/themes/app_colors.dart';
import 'package:app/features/settings/bloc/settings_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SettingsDarkMode extends StatelessWidget {
  const SettingsDarkMode({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDarkModeOn = context.select(
      (SettingsBloc bloc) => bloc.state.isDarkModeOn,
    );
    final bool isDarkModeCompatibilityWithSystemOn = context.select(
      (SettingsBloc bloc) => bloc.state.isDarkModeCompatibilityWithSystemOn,
    );

    return ListTile(
      leading: const Icon(MdiIcons.shieldMoonOutline),
      title: const Text('Ciemny motyw'),
      contentPadding: const EdgeInsets.only(left: 16),
      trailing: Switch(
        value: isDarkModeOn,
        onChanged: isDarkModeCompatibilityWithSystemOn
            ? null
            : (bool isSwitched) => _onSwitched(isSwitched, context),
        activeColor: AppColors.primary,
      ),
    );
  }

  void _onSwitched(bool isSwitched, BuildContext context) {
    context.read<SettingsBloc>().add(
          SettingsEventSwitchDarkMode(isSwitched: isSwitched),
        );
  }
}
