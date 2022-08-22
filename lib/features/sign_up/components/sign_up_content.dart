import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../components/on_tap_focus_lose_area_component.dart';
import '../../../config/themes/app_colors.dart';
import '../../../interfaces/factories/icon_factory.dart';
import '../../../interfaces/factories/widget_factory.dart';
import 'sign_up_avatar.dart';
import 'sign_up_inputs.dart';
import 'sign_up_submit_button.dart';

class SignUpContent extends StatelessWidget {
  const SignUpContent({super.key});

  @override
  Widget build(BuildContext context) {
    final WidgetFactory widgetFactory = context.read<WidgetFactory>();
    final IconFactory iconFactory = context.read<IconFactory>();

    return widgetFactory.createScaffold(
      appBarTitle: 'Rejestracja',
      appBarBackgroundColor: AppColors.background,
      appBarWithElevation: false,
      leadingIcon: iconFactory.createCloseIcon(),
      child: SafeArea(
        child: OnTapFocusLoseAreaComponent(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 24,
                right: 24,
                bottom: 24,
                top: 16,
              ),
              child: Column(
                children: const [
                  SignUpAvatar(),
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
    );
  }
}

class _AlternativeOptions extends StatelessWidget {
  const _AlternativeOptions();

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontSize: 12,
      color: AppColors.grey,
    );
    return Column(
      children: [
        GestureDetector(
          onTap: () => _onSignInPressed(context),
          child: Text(
            'Masz już konto? Wróć do logowania!',
            style: textStyle,
          ),
        ),
      ],
    );
  }

  void _onSignInPressed(BuildContext context) {
    Navigator.pop(context);
  }
}
