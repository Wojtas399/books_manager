import 'package:app/components/custom_scaffold_component.dart';
import 'package:app/components/on_tap_focus_lose_area_component.dart';
import 'package:app/config/themes/app_colors.dart';
import 'package:app/extensions/navigator_build_context_extension.dart';
import 'package:app/features/sign_up/components/sign_up_inputs.dart';
import 'package:app/features/sign_up/components/sign_up_submit_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SignUpContent extends StatelessWidget {
  const SignUpContent({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      leadingIcon: MdiIcons.close,
      appBarWithElevation: false,
      appBarColor: AppColors.lightBackground,
      foregroundColor: Colors.black,
      systemUiOverlayStyle: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      body: const SafeArea(
        child: OnTapFocusLoseAreaComponent(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  children: [
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
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
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
    context.navigateBack();
  }
}
