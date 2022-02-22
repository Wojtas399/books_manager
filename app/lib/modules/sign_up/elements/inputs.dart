import 'package:app/widgets/text_fields/basic_text_form_field.dart';
import 'package:app/widgets/text_fields/password_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:app/modules/sign_up/sign_up_bloc.dart';
import 'package:app/modules/sign_up/sign_up_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../sign_up_screen.dart';

class SignUpUsernameInput extends StatelessWidget {
  const SignUpUsernameInput();

  @override
  Widget build(BuildContext context) {
    bool isCorrect = false;
    return SignUpBlocConsumer(
      stateListener: (state) {
        isCorrect = state.isCorrectUsername;
      },
      builder: (context, _) {
        return _InputContainer(
          child: BasicTextFormField(
            label: 'Nazwa użytkownika',
            placeholder: 'np. Jan Nowak',
            onChanged: (String value) => _changeUsernameValue(context, value),
            validator: (String? value) => _validate(
              value,
              isCorrect,
              'Nazwa użytkownika musi zawierać co najmniej 3 znaki',
            ),
          ),
        );
      },
    );
  }

  _changeUsernameValue(BuildContext context, String value) {
    context.read<SignUpBloc>().add(SignUpUsernameChanged(username: value));
  }
}

class SignUpEmailInput extends StatelessWidget {
  const SignUpEmailInput();

  @override
  Widget build(BuildContext context) {
    bool isCorrect = false;
    return SignUpBlocConsumer(
      stateListener: (state) {
        isCorrect = state.isCorrectEmail;
      },
      builder: (context, _) {
        return _InputContainer(
          child: BasicTextFormField(
            label: 'Adres e-mail',
            placeholder: 'np. jan.nowak@example.com',
            onChanged: (String value) => _changeEmailValue(context, value),
            validator: (String? value) => _validate(
              value,
              isCorrect,
              'Niepoprawny adres-email',
            ),
          ),
        );
      },
    );
  }

  _changeEmailValue(BuildContext context, String value) {
    context.read<SignUpBloc>().add(SignUpEmailChanged(email: value));
  }
}

class SignUpPasswordInput extends StatelessWidget {
  const SignUpPasswordInput();

  @override
  Widget build(BuildContext context) {
    bool isCorrect = false;
    return SignUpBlocConsumer(
      stateListener: (state) {
        isCorrect = state.isCorrectPassword;
      },
      builder: (context, _) {
        return _InputContainer(
          child: PasswordTextFormField(
            label: 'Hasło',
            onChanged: (String value) => _changePasswordValue(context, value),
            validator: (String? value) => _validate(
              value,
              isCorrect,
              'Hasło musi się składać z co najmniej 6 liter',
            ),
          ),
        );
      },
    );
  }

  _changePasswordValue(BuildContext context, String value) {
    context.read<SignUpBloc>().add(SignUpPasswordChanged(password: value));
  }
}

class SignUpPasswordConfirmationInput extends StatelessWidget {
  const SignUpPasswordConfirmationInput();

  @override
  Widget build(BuildContext context) {
    bool isCorrect = false;
    return SignUpBlocConsumer(
      stateListener: (state) {
        isCorrect = state.isCorrectPasswordConfirmation;
      },
      builder: (context, _) {
        return _InputContainer(
          child: PasswordTextFormField(
            label: 'Powtórz hasło',
            onChanged: (String value) => _changePasswordConfirmationValue(
              context,
              value,
            ),
            validator: (String? value) => _validate(
              value,
              isCorrect,
              'Hasła nie są jednakowe',
            ),
          ),
        );
      },
    );
  }

  _changePasswordConfirmationValue(BuildContext context, String value) {
    context.read<SignUpBloc>().add(SignUpPasswordConfirmationChanged(
          passwordConfirmation: value,
        ));
  }
}

class _InputContainer extends StatelessWidget {
  final Widget child;

  const _InputContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      child: child,
    );
  }
}

String? _validate(
  String? value,
  bool isCorrect,
  String incorrectValueMessage,
) {
  if (value == '') {
    return 'To pole jest wymagane';
  } else if (!isCorrect) {
    return incorrectValueMessage;
  }
  return null;
}
