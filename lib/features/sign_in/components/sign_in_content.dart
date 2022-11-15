import 'package:app/components/on_tap_focus_lose_area_component.dart';
import 'package:app/config/themes/app_colors.dart';
import 'package:app/config/themes/global_material_theme.dart';
import 'package:app/extensions/navigator_build_context_extension.dart';
import 'package:app/features/sign_in/bloc/sign_in_bloc.dart';
import 'package:app/features/sign_in/components/sign_in_form_card.dart';
import 'package:app/features/sign_in/components/sign_in_inputs.dart';
import 'package:app/features/sign_in/components/sign_in_submit_button.dart';
import 'package:app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInContent extends StatelessWidget {
  const SignInContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: GlobalMaterialTheme.lightTheme,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Scaffold(
          body: SafeArea(
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
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 330,
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
    context.navigateToResetPasswordScreen();
    _cleanForm(context);
    _unfocusInputs();
  }

  void _onSignUpPressed(BuildContext context) {
    context.navigateToSignUpScreen();
    _cleanForm(context);
    _unfocusInputs();
  }

  void _cleanForm(BuildContext context) {
    context.read<SignInBloc>().add(
          const SignInEventCleanForm(),
        );
  }

  void _unfocusInputs() {
    Utils.unfocusInputs();
  }
}
