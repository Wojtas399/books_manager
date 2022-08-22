import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../../interfaces/factories/icon_factory.dart';
import '../../../interfaces/factories/widget_factory.dart';
import '../bloc/sign_in_bloc.dart';

class SignInInputs extends StatelessWidget {
  const SignInInputs({super.key});

  @override
  Widget build(BuildContext context) {
    final WidgetFactory widgetFactory = context.read<WidgetFactory>();
    final IconFactory iconFactory = context.read<IconFactory>();

    return Column(
      children: [
        widgetFactory.createTextFormField(
          placeholder: 'Adres email',
          icon: iconFactory.createAccountIcon(),
          keyboardType: TextInputType.emailAddress,
          onChanged: (String email) => _onEmailChanged(email, context),
        ),
        const SizedBox(height: 24.0),
        widgetFactory.createTextFormField(
          placeholder: 'Hasło',
          icon: iconFactory.createLockIcon(),
          isPassword: true,
          onChanged: (String password) => _onPasswordChanged(password, context),
        ),
      ],
    );
  }

  void _onEmailChanged(String value, BuildContext context) {
    context.read<SignInBloc>().add(
          SignInEventEmailChanged(email: value),
        );
  }

  void _onPasswordChanged(String value, BuildContext context) {
    context.read<SignInBloc>().add(
          SignInEventPasswordChanged(password: value),
        );
  }
}
