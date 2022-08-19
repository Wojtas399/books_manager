import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../interfaces/factories/icon_factory_interface.dart';
import '../../../interfaces/factories/widget_factory_interface.dart';
import '../bloc/sign_up_bloc.dart';

class SignUpInputs extends StatelessWidget {
  const SignUpInputs({super.key});

  @override
  Widget build(BuildContext context) {
    final widgetFactory = context.read<WidgetFactoryInterface>();
    final iconFactory = context.read<IconFactoryInterface>();
    return Column(
      children: [
        widgetFactory.createTextFormField(
          placeholder: 'Nazwa użytkownika',
          icon: iconFactory.createAccountIcon(),
          onChanged: (String username) => _onUsernameChanged(username, context),
        ),
        const SizedBox(height: 24.0),
        widgetFactory.createTextFormField(
          placeholder: 'Adres email',
          icon: iconFactory.createEnvelopeIcon(),
          onChanged: (String email) => _onEmailChanged(email, context),
        ),
        const SizedBox(height: 24.0),
        widgetFactory.createTextFormField(
          placeholder: 'Hasło',
          icon: iconFactory.createLockIcon(),
          isPassword: true,
          onChanged: (String password) => _onPasswordChanged(password, context),
        ),
        const SizedBox(height: 24.0),
        widgetFactory.createTextFormField(
          placeholder: 'Powtórz hasło',
          icon: iconFactory.createLockIcon(),
          isPassword: true,
          onChanged: (String passwordConfirmation) =>
              _onPasswordConfirmationChanged(passwordConfirmation, context),
        ),
      ],
    );
  }

  void _onUsernameChanged(String username, BuildContext context) {
    context.read<SignUpBloc>().add(
          SignUpEventUsernameChanged(username: username),
        );
  }

  void _onEmailChanged(String email, BuildContext context) {
    context.read<SignUpBloc>().add(
          SignUpEventEmailChanged(email: email),
        );
  }

  void _onPasswordChanged(String password, BuildContext context) {
    context.read<SignUpBloc>().add(
          SignUpEventPasswordChanged(password: password),
        );
  }

  void _onPasswordConfirmationChanged(
    String passwordConfirmation,
    BuildContext context,
  ) {
    context.read<SignUpBloc>().add(
          SignUpEventPasswordConfirmationChanged(
              passwordConfirmation: passwordConfirmation),
        );
  }
}
