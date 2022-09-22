import 'package:app/components/list_tile_component.dart';
import 'package:app/components/password_change_component.dart';
import 'package:app/config/animations/slide_up_route_animation.dart';
import 'package:app/features/settings/bloc/settings_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  Future<void> _onTap(BuildContext context) async {
    final SettingsBloc settingsBloc = context.read<SettingsBloc>();
    final PasswordChangeComponentReturnedValues? passwords =
        await _askForPasswords(context);
    if (passwords != null) {
      settingsBloc.add(
        SettingsEventChangePassword(
          currentPassword: passwords.currentPassword,
          newPassword: passwords.newPassword,
        ),
      );
    }
  }

  Future<PasswordChangeComponentReturnedValues?> _askForPasswords(
    BuildContext context,
  ) async {
    return await Navigator.push<PasswordChangeComponentReturnedValues?>(
      context,
      SlideUpRouteAnimation<PasswordChangeComponentReturnedValues?>(
        page: const PasswordChangeComponent(),
      ),
    );
  }
}
