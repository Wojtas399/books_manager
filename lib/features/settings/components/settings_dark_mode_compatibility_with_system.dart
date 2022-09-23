import 'package:app/config/themes/app_colors.dart';
import 'package:app/features/settings/bloc/settings_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SettingsDarkModeCompatibilityWithSystem extends StatelessWidget {
  const SettingsDarkModeCompatibilityWithSystem({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDarkModeCompatibilityWithSystemOn = context.select(
      (SettingsBloc bloc) => bloc.state.isDarkModeCompatibilityWithSystemOn,
    );

    return ListTile(
      leading: const Icon(MdiIcons.shieldSyncOutline),
      title: const Text('Motyw systemowy'),
      contentPadding: const EdgeInsets.only(left: 16),
      trailing: Switch(
        value: isDarkModeCompatibilityWithSystemOn,
        onChanged: (bool isSwitched) => _onSwitched(isSwitched, context),
        activeColor: AppColors.primary,
      ),
    );
  }

  void _onSwitched(bool isSwitched, BuildContext context) {
    context.read<SettingsBloc>().add(
          SettingsEventSwitchDarkModeCompatibilityWithSystem(
            isSwitched: isSwitched,
          ),
        );
  }
}
