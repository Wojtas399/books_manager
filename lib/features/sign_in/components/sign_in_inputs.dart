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
        _Email(),
        const SizedBox(height: 24.0),
        _Password(),
      ],
    );
  }
}

class _Email extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final String email = context.select(
      (SignInBloc bloc) => bloc.state.email,
    );
    if (email == '') {
      _controller.clear();
    }

    return CustomTextField(
      controller: _controller,
      placeholder: 'Adres email',
      iconData: MdiIcons.account,
      keyboardType: TextInputType.emailAddress,
      onChanged: (String email) => _onEmailChanged(email, context),
    );
  }

  void _onEmailChanged(String value, BuildContext context) {
    context.read<SignInBloc>().add(
          SignInEventEmailChanged(email: value),
        );
  }
}

class _Password extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final String password = context.select(
      (SignInBloc bloc) => bloc.state.password,
    );
    if (password == '') {
      _controller.clear();
    }

    return PasswordTextField(
      controller: _controller,
      placeholder: 'Hasło',
      onChanged: (String password) => _onPasswordChanged(password, context),
    );
  }

  void _onPasswordChanged(String value, BuildContext context) {
    context.read<SignInBloc>().add(
          SignInEventPasswordChanged(password: value),
        );
  }
}
