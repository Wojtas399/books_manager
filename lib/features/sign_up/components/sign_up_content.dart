import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../components/custom_scaffold.dart';
import '../../../components/on_tap_focus_lose_area_component.dart';
import '../../../config/themes/app_colors.dart';
import 'sign_up_inputs.dart';
import 'sign_up_submit_button.dart';

class SignUpContent extends StatelessWidget {
  const SignUpContent({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      leadingIcon: MdiIcons.close,
      appBarWithElevation: false,
      appBarColor: AppColors.lightBackground,
      foregroundColor: Colors.black,
      body: SafeArea(
        child: OnTapFocusLoseAreaComponent(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: const [
                    _Title(),
                    SizedBox(height: 32),
                    SignUpInputs(),
                    SizedBox(height: 32),
                    SignUpSubmitButton(),
                    SizedBox(height: 16),
                    _AlternativeOptions(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title();

  @override
  Widget build(BuildContext context) {
    return Text(
      'Rejestracja',
      style: Theme.of(context).textTheme.headline4?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w500,
          ),
    );
  }
}

class _AlternativeOptions extends StatelessWidget {
  const _AlternativeOptions();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => _onSignInPressed(context),
          child: Text(
            'Masz już konto? Wróć do logowania!',
            style: TextStyle(
              fontSize: 12,
              color: Colors.black.withOpacity(0.5),
            ),
          ),
        ),
      ],
    );
  }

  void _onSignInPressed(BuildContext context) {
    Navigator.pop(context);
  }
}
