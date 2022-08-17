import 'package:app/config/themes/app_colors.dart';
import 'package:app/core/services/validation_service.dart';
import 'package:app/widgets/app_bars/dialog_app_bar.dart';
import 'package:app/widgets/buttons/medium_red_button.dart';
import 'package:app/widgets/buttons/medium_green_button.dart';
import 'package:app/widgets/text_fields/basic_text_form_field.dart';
import 'package:app/widgets/text_fields/password_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class EmailDialog extends StatelessWidget {
  final ValidationService validationService = ValidationService();
  final String currentEmail;

  EmailDialog({required this.currentEmail});

  @override
  Widget build(BuildContext context) {
    TextEditingController _emailController = TextEditingController(
      text: currentEmail,
    );
    TextEditingController _passwordController = TextEditingController(
      text: '',
    );
    ValueNotifier<bool> _isEmailCorrect = ValueNotifier<bool>(false);
    ValueNotifier<bool> _isPasswordCorrect = ValueNotifier<bool>(false);

    return Scaffold(
      appBar: DialogAppBar(title: 'Zmień adres e-mail'),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 24),
        color: HexColor(AppColors.LIGHT_BLUE),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _Email(
              currentEmail: currentEmail,
              emailController: _emailController,
              isEmailCorrect: _isEmailCorrect,
            ),
            SizedBox(height: 24),
            _Password(
              passwordController: _passwordController,
              isPasswordCorrect: _isPasswordCorrect,
            ),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MediumRedButton(
                  text: 'Anuluj',
                  icon: Icons.close,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                SizedBox(width: 24),
                _SubmitButton(
                  emailController: _emailController,
                  passwordController: _passwordController,
                  isEmailCorrect: _isEmailCorrect,
                  isPasswordCorrect: _isPasswordCorrect,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class EmailDialogResult {
  final String newEmail;
  final String password;

  EmailDialogResult({required this.newEmail, required this.password});
}

class _Email extends StatelessWidget {
  final ValidationService validationService = ValidationService();
  final String currentEmail;
  final TextEditingController emailController;
  final ValueNotifier isEmailCorrect;

  _Email({
    required this.currentEmail,
    required this.emailController,
    required this.isEmailCorrect,
  });

  @override
  Widget build(BuildContext context) {
    return BasicTextFormField(
      label: 'Adres e-mail',
      controller: emailController,
      validator: (val) {
        if (val == '') {
          return 'To pole jest wymagane';
        } else if (!validationService.checkValue(
          ValidationKey.email,
          val ?? '',
        )) {
          return 'Niepoprawny adres e-mail';
        }
        return null;
      },
      onChanged: (val) {
        isEmailCorrect.value = val != '' &&
            val != currentEmail &&
            validationService.checkValue(ValidationKey.email, val);
      },
    );
  }
}

class _Password extends StatelessWidget {
  final TextEditingController passwordController;
  final ValueNotifier isPasswordCorrect;

  const _Password({
    required this.passwordController,
    required this.isPasswordCorrect,
  });

  @override
  Widget build(BuildContext context) {
    return PasswordTextFormField(
      label: 'Hasło',
      controller: passwordController,
      validator: (val) {
        if (val == '') {
          return 'To pole jest wymagane';
        }
        return null;
      },
      onChanged: (val) {
        isPasswordCorrect.value = val != '';
      },
    );
  }
}

class _SubmitButton extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final ValueNotifier isEmailCorrect;
  final ValueNotifier isPasswordCorrect;

  const _SubmitButton({
    required this.emailController,
    required this.passwordController,
    required this.isEmailCorrect,
    required this.isPasswordCorrect,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isEmailCorrect,
      builder: (_, isEmailCorrect, child) {
        return ValueListenableBuilder(
          valueListenable: isPasswordCorrect,
          builder: (_, isPasswordCorrect, child) {
            return MediumGreenButton(
              text: 'Zapisz',
              icon: Icons.check,
              onPressed: isEmailCorrect == false || isPasswordCorrect == false
                  ? null
                  : () => Navigator.pop(
                      context,
                      EmailDialogResult(
                        newEmail: emailController.text,
                        password: passwordController.text,
                      )),
            );
          },
        );
      },
    );
  }
}
