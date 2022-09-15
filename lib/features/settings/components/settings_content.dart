import 'package:app/components/custom_button.dart';
import 'package:app/components/custom_scaffold.dart';
import 'package:app/domain/interfaces/dialog_interface.dart';
import 'package:app/features/settings/bloc/settings_bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsContent extends StatelessWidget {
  const SettingsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarTitle: 'Ustawienia',
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomButton(
              label: 'Wyloguj',
              onPressed: () => _onSignOutButtonPressed(context),
            ),
            const SizedBox(height: 16),
            CustomButton(
              label: 'Usuń konto',
              onPressed: () => _onDeleteAccountPressed(context),
            ),
          ],
        ),
      ),
    );
  }

  void _onSignOutButtonPressed(BuildContext context) {
    context.read<SettingsBloc>().add(
          SettingsEventSignOut(),
        );
  }

  Future<void> _onDeleteAccountPressed(BuildContext context) async {
    final SettingsBloc settingsBloc = context.read<SettingsBloc>();
    final String? password = await _askForPassword(context);
    if (password != null) {
      settingsBloc.add(
        SettingsEventDeleteAccount(password: password),
      );
    }
  }

  Future<String?> _askForPassword(BuildContext context) async {
    return await context.read<DialogInterface>().askForValue(
          title: 'Usuwanie konta',
          message:
              'Operacja ta jest nieodwracalna i spowoduje usunięcie wszystkich zapisanych dotychczas danych. \nPodaj hasło jeśli chcesz kontynuować:',
          placeholder: 'Hasło',
          obscureText: true,
        );
  }
}
