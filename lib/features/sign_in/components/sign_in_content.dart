import 'package:flutter/material.dart';

import '../../../components/on_tap_focus_lose_area_component.dart';
import '../../../config/navigation.dart';
import '../../../config/themes/app_colors.dart';
import 'sign_in_background.dart';
import 'sign_in_form_card.dart';
import 'sign_in_inputs.dart';
import 'sign_in_submit_button.dart';

class SignInContent extends StatelessWidget {
  const SignInContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SignInBackground(
        child: SafeArea(
          child: OnTapFocusLoseAreaComponent(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const _Logo(),
                    const SizedBox(height: 32),
                    SignInFormCard(
                      child: Column(
                        children: const [
                          _Title(),
                          SizedBox(height: 32),
                          SignInInputs(),
                          SizedBox(height: 32),
                          SignInSubmitButton(),
                          SizedBox(height: 16),
                          _AlternativeOptions(),
                        ],
                      ),
                    )
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

class _Logo extends StatelessWidget {
  const _Logo();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      child: Image.asset('assets/images/Logo.png'),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title();

  @override
  Widget build(BuildContext context) {
    return Text(
      'Logowanie',
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
    final textStyle = TextStyle(
      fontSize: 12,
      color: Colors.black.withOpacity(0.5),
    );
    return Column(
      children: [
        GestureDetector(
          onTap: () => _onForgotPasswordPressed(context),
          child: Text(
            'Nie pamiętasz hasła?',
            style: textStyle,
          ),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () => _onSignUpPressed(context),
          child: Text(
            'Nie masz jeszcze konta? Zarejestruj się!',
            style: textStyle,
          ),
        ),
      ],
    );
  }

  void _onForgotPasswordPressed(BuildContext context) {
    Navigation.navigateToResetPasswordScreen(context: context);
  }

  void _onSignUpPressed(BuildContext context) {
    Navigation.navigateToSignUpScreen(context: context);
  }
}
