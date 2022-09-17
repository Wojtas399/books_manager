import 'package:app/components/custom_scaffold.dart';
import 'package:app/features/settings/components/settings_account_deletion.dart';
import 'package:app/features/settings/components/settings_dark_mode.dart';
import 'package:app/features/settings/components/settings_password_change.dart';
import 'package:app/features/settings/components/settings_sign_out.dart';
import 'package:flutter/material.dart';

class SettingsContent extends StatelessWidget {
  const SettingsContent({super.key});

  @override
  Widget build(BuildContext context) {
    const Widget divider = Divider(thickness: 0.6);

    return CustomScaffold(
      appBarTitle: 'Ustawienia',
      body: Padding(
        padding: const EdgeInsets.only(top: 24, left: 16, right: 16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: const [
              SettingsDarkMode(),
              divider,
              SettingsPasswordChange(),
              divider,
              SettingsSignOut(),
              divider,
              SettingsAccountDeletion(),
            ],
          ),
        ),
      ),
    );
  }
}
