import 'package:app/config/themes/button_theme.dart';
import 'package:app/config/themes/app_colors.dart';
import 'package:app/modules/sign_in/sign_in_actions.dart';
import 'package:app/modules/sign_in/sign_in_bloc.dart';
import 'package:app/modules/sign_in/sign_in_state.dart';
import 'package:app/widgets/text_fields/basic_text_form_field.dart';
import 'package:app/widgets/text_fields/password_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;

  const SignInForm({required this.formKey});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _EmailInput(),
          SizedBox(height: 25),
          _PasswordInput(),
          SizedBox(height: 25),
          _SubmitButton(),
        ],
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  const _EmailInput();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignInBloc, SignInState>(
      builder: (context, state) {
        return Container(
          width: 300,
          child: BasicTextFormField(
            label: 'Adres e-mail',
            onChanged: (value) => _onEmailChanged(context, value),
          ),
        );
      },
    );
  }

  _onEmailChanged(BuildContext context, String email) {
    context.read<SignInBloc>().add(SignInEmailChanged(email: email));
  }
}

class _PasswordInput extends StatelessWidget {
  const _PasswordInput();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignInBloc, SignInState>(
      builder: (context, state) {
        return Container(
          width: 300,
          child: PasswordTextFormField(
            label: 'Hasło',
            onChanged: (value) => _onPasswordChanged(context, value),
          ),
        );
      },
    );
  }

  _onPasswordChanged(BuildContext context, String password) {
    context.read<SignInBloc>().add(SignInPasswordChanged(password: password));
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignInBloc, SignInState>(
      builder: (context, state) {
        return ElevatedButton(
          child: Text('ZALOGUJ'),
          style: ButtonStyles.bigButton(
            color: AppColors.DARK_GREEN2,
            context: context,
          ),
          onPressed: state.isDisabledButton
              ? null
              : () => _submit(context, state.email, state.password),
        );
      },
    );
  }

  _submit(BuildContext context, String email, String password) {
    context
        .read<SignInBloc>()
        .add(SignInSubmitted(email: email, password: password));
  }
}
