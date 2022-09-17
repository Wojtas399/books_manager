import 'package:app/components/list_tile_component.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SettingsPasswordChange extends StatelessWidget {
  const SettingsPasswordChange({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTileComponent(
      title: 'Zmień hasło',
      iconData: MdiIcons.lock,
      onPressed: () => _onTap(context),
    );
  }

  void _onTap(BuildContext context) {
    //TODO
  }
}
