import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SettingsDarkMode extends StatelessWidget {
  const SettingsDarkMode({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(MdiIcons.brightness6),
      title: const Text('Ciemny motyw'),
      contentPadding: const EdgeInsets.only(left: 16),
      trailing: Switch(
        value: false,
        onChanged: (bool isSwitched) => _onSwitched(isSwitched, context),
      ),
    );
  }

  void _onSwitched(bool isSwitched, BuildContext context) {
    //TODO
  }
}
