import 'package:flutter/material.dart';
import 'package:app/widgets/text_fields/password_text_form_field.dart';
import 'package:app/widgets/text_fields/basic_text_form_field.dart';
import 'package:app/modules/sign_up/sign_up_bloc.dart';
import 'package:app/modules/sign_up/sign_up_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../sing_up_state.dart';

class SignUpInputs {
  Widget username() {
    bool _isCorrect = false;
    return BlocConsumer<SignUpBloc, SignUpState>(
      listener: (context, state) {
        _isCorrect = state.isCorrectUsername;
      },
      builder: (context, state) {
        return Container(
          width: 300,
          child: BasicTextFormField(
            label: 'Nazwa użytkownika',
            placeholder: 'np. Jan Nowak',
            onChanged: (value) {
              context.read<SignUpBloc>().add(
                    SignUpUsernameChanged(username: value),
                  );
            },
            validator: (value) => _validator(
              value ?? '',
              _isCorrect,
              'Nazwa użytkownika musi zawierać co najmniej 3 znaki',
            ),
          ),
        );
      },
    );
  }

  Widget email() {
    bool _isCorrect = false;
    return BlocConsumer<SignUpBloc, SignUpState>(
      listener: (context, state) {
        _isCorrect = state.isCorrectEmail;
      },
      builder: (context, state) {
        return Container(
          width: 300,
          child: BasicTextFormField(
            label: 'Adres e-mail',
            placeholder: 'np. jan.nowak@example.com',
            onChanged: (value) {
              context.read<SignUpBloc>().add(
                SignUpEmailChanged(email: value),
              );
            },
            validator: (value) => _validator(
              value ?? '',
              _isCorrect,
              'Niepoprawny adres e-mail',
            ),
          ),
        );
      },
    );
  }

  Widget password() {
    bool _isCorrect = false;
    return BlocConsumer<SignUpBloc, SignUpState>(
      listener: (context, state) {
        _isCorrect = state.isCorrectPassword;
      },
      builder: (context, state) {
        return Container(
          width: 300,
          child: PasswordTextFormField(
            label: 'Hasło',
            onChanged: (value) {
              context.read<SignUpBloc>().add(
                SignUpPasswordChanged(password: value),
              );
            },
            validator: (value) => _validator(
              value ?? '',
              _isCorrect,
              'Hasło musi zawierać co najmniej 6 znaków',
            ),
          ),
        );
      },
    );
  }

  Widget passwordConfirmation() {
    bool _isCorrect = false;
    return BlocConsumer<SignUpBloc, SignUpState>(
      listener: (context, state) {
        _isCorrect = state.isCorrectPasswordConfirmation;
      },
      builder: (context, state) {
        return Container(
          width: 300,
          child: PasswordTextFormField(
            label: 'Powtórz hasło',
            onChanged: (value) {
              context.read<SignUpBloc>().add(
                SignUpPasswordConfirmationChanged(passwordConfirmation: value),
              );
            },
            validator: (value) => _validator(
              value ?? '',
              _isCorrect,
              'Hasła nie są jednakowe',
            ),
          ),
        );
      },
    );
  }

  String? _validator(String value, bool isGood, String message) {
    if (value == '') {
      return 'To pole jest wymagane';
    } else if (!isGood) {
      return message;
    }
    return null;
  }
}
