import 'package:app/components/list_tile_component.dart';
import 'package:app/extensions/dialogs_build_context_extension.dart';
import 'package:app/features/settings/bloc/settings_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SettingsAccountDeletion extends StatelessWidget {
  const SettingsAccountDeletion({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTileComponent(
      title: 'Usuń konto',
      iconData: MdiIcons.delete,
      color: Colors.red,
      boldText: true,
      onPressed: () => _onPressed(context),
    );
  }

  Future<void> _onPressed(BuildContext context) async {
    final SettingsBloc settingsBloc = context.read<SettingsBloc>();
    final String? password = await _askForPassword(context);
    if (password != null) {
      settingsBloc.add(
        SettingsEventDeleteAccount(password: password),
      );
    }
  }

  Future<String?> _askForPassword(BuildContext context) async {
    return await context.askForValue(
      title: 'Usuwanie konta',
      message:
          'Operacja ta jest nieodwracalna i spowoduje usunięcie wszystkich zapisanych dotychczas danych. \nPodaj hasło jeśli chcesz kontynuować:',
      placeholder: 'Hasło',
      obscureText: true,
    );
  }
}
