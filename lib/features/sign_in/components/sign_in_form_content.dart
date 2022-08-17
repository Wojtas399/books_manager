import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../config/themes/app_colors.dart';
import '../../../interfaces/factories/text_factory_interface.dart';
import 'sign_in_inputs.dart';
import 'sign_in_submit_button.dart';

class SignInFormContent extends StatelessWidget {
  const SignInFormContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: const [
          _Title(),
          SizedBox(height: 32),
          SignInInputs(),
          SizedBox(height: 32),
          SignInSubmitButton(),
          SizedBox(height: 24),
          _AlternativeOptions(),
        ],
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title();

  @override
  Widget build(BuildContext context) {
    final textFactory = context.read<TextFactoryInterface>();
    return textFactory.createTitleText(
      text: 'Logowanie',
      color: AppColors.darkGreen,
      context: context,
    );
  }
}

class _AlternativeOptions extends StatelessWidget {
  const _AlternativeOptions();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Zapomniałeś hasła?',
          style: TextStyle(
            fontSize: 12,
            color: AppColors.grey,
          ),
        ),
        const SizedBox(height: 12),
        Text('Nie masz jeszcze konta? Zarejestruj się!',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.grey,
            )),
      ],
    );
  }
}
