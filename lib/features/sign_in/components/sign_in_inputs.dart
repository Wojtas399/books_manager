import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../../../components/custom_text_field.dart';
import '../../../components/password_text_field.dart';
import '../bloc/sign_in_bloc.dart';

class SignInInputs extends StatelessWidget {
  const SignInInputs({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextField(
          placeholder: 'Adres email',
          iconData: MdiIcons.account,
          keyboardType: TextInputType.emailAddress,
          onChanged: (String email) => _onEmailChanged(email, context),
        ),
        const SizedBox(height: 24.0),
        PasswordTextField(
          placeholder: 'Hasło',
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
