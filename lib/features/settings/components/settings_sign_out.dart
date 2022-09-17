import 'package:app/components/list_tile_component.dart';
import 'package:app/features/settings/bloc/settings_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SettingsSignOut extends StatelessWidget {
  const SettingsSignOut({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTileComponent(
      title: 'Wyloguj',
      iconData: MdiIcons.logout,
      onPressed: () => _onPressed(context),
    );
  }

  void _onPressed(BuildContext context) {
    context.read<SettingsBloc>().add(
          SettingsEventSignOut(),
        );
  }
}
