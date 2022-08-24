import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../components/custom_text_field.dart';
import '../../../components/password_text_field.dart';
import '../../../ui/errors_messages.dart';
import '../bloc/sign_up_bloc.dart';

class SignUpInputs extends StatelessWidget {
  const SignUpInputs({super.key});

  @override
  Widget build(BuildContext context) {
    const Widget gap = SizedBox(height: 24.0);
    return Column(
      children: const [
        _Email(),
        gap,
        _Password(),
        gap,
        _PasswordConfirmation(),
      ],
    );
  }
}

class _Email extends StatelessWidget {
  const _Email();

  @override
  Widget build(BuildContext context) {
    final bool isEmailValid = context.select(
      (SignUpBloc bloc) => bloc.state.isEmailValid,
    );

    return CustomTextField(
      placeholder: 'Adres email',
      iconData: MdiIcons.email,
      validator: (_) => _validate(isEmailValid),
      onChanged: (String email) => _onEmailChanged(email, context),
    );
  }

  String? _validate(bool isEmailValid) {
    if (isEmailValid) {
      return null;
    }
    return ErrorsMessages.invalidEmail;
  }

  void _onEmailChanged(String email, BuildContext context) {
    context.read<SignUpBloc>().add(
          SignUpEventEmailChanged(email: email),
        );
  }
}

class _Password extends StatelessWidget {
  const _Password();

  @override
  Widget build(BuildContext context) {
    final bool isPasswordValid = context.select(
      (SignUpBloc bloc) => bloc.state.isPasswordValid,
    );

    return PasswordTextField(
      placeholder: 'Hasło',
      isRequired: true,
      validator: (_) => _validate(isPasswordValid),
      onChanged: (String password) => _onPasswordChanged(password, context),
    );
  }

  String? _validate(bool isPasswordValid) {
    if (isPasswordValid) {
      return null;
    }
    return ErrorsMessages.invalidPassword;
  }

  void _onPasswordChanged(String password, BuildContext context) {
    context.read<SignUpBloc>().add(
          SignUpEventPasswordChanged(password: password),
        );
  }
}

class _PasswordConfirmation extends StatelessWidget {
  const _PasswordConfirmation();

  @override
  Widget build(BuildContext context) {
    final bool isPasswordConfirmationValid = context.select(
      (SignUpBloc bloc) => bloc.state.isPasswordConfirmationValid,
    );

    return PasswordTextField(
      placeholder: 'Powtórz hasło',
      isRequired: true,
      validator: (_) => _validate(isPasswordConfirmationValid),
      onChanged: (String password) => _onPasswordConfirmationChanged(
        password,
        context,
      ),
    );
  }

  String? _validate(bool isPasswordConfirmationValid) {
    if (isPasswordConfirmationValid) {
      return null;
    }
    return 'Hasła nie są jednakowe';
  }

  void _onPasswordConfirmationChanged(
    String passwordConfirmation,
    BuildContext context,
  ) {
    context.read<SignUpBloc>().add(
          SignUpEventPasswordConfirmationChanged(
            passwordConfirmation: passwordConfirmation,
          ),
        );
  }
}
