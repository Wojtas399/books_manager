import 'package:app/common/ui/snack_bars.dart';
import 'package:app/constants/theme.dart';
import 'package:app/widgets/app_bars/dialog_app_bar.dart';
import 'package:app/widgets/buttons/medium_red_button.dart';
import 'package:app/widgets/buttons/medium_green_button.dart';
import 'package:app/widgets/text_fields/password_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class PasswordDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController _currentPasswordController =
        TextEditingController(text: '');
    TextEditingController _newPasswordController =
        TextEditingController(text: '');
    TextEditingController _newPasswordConfirmationController =
        TextEditingController(text: '');
    ValueNotifier<bool> _isCorrectCurrentPassword = ValueNotifier<bool>(false);
    ValueNotifier<bool> _isCorrectNewPassword = ValueNotifier<bool>(false);
    ValueNotifier<bool> _isCorrectNewPasswordConfirmation =
        ValueNotifier<bool>(false);

    return Scaffold(
      appBar: DialogAppBar(title: 'Zmień hasło'),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 24),
        color: HexColor(AppColors.LIGHT_BLUE),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _CurrentPassword(
              controller: _currentPasswordController,
              isCorrectNotifier: _isCorrectCurrentPassword,
            ),
            SizedBox(height: 24),
            _NewPassword(
              controller: _newPasswordController,
              isCorrectNotifier: _isCorrectNewPassword,
            ),
            SizedBox(height: 24),
            _NewPasswordConfirmation(
              controller: _newPasswordConfirmationController,
              isCorrectNotifier: _isCorrectNewPasswordConfirmation,
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
                  currentPasswordController: _currentPasswordController,
                  newPasswordController: _newPasswordController,
                  newPasswordConfirmationController:
                      _newPasswordConfirmationController,
                  isCorrectCurrentPasswordNotifier: _isCorrectCurrentPassword,
                  isCorrectNewPasswordNotifier: _isCorrectNewPassword,
                  isCorrectNewPasswordConfirmationNotifier:
                      _isCorrectNewPasswordConfirmation,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PasswordDialogResult {
  final String currentPassword;
  final String newPassword;

  PasswordDialogResult({
    required this.currentPassword,
    required this.newPassword,
  });
}

class _CurrentPassword extends StatelessWidget {
  final TextEditingController controller;
  final ValueNotifier isCorrectNotifier;

  const _CurrentPassword({
    required this.controller,
    required this.isCorrectNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return PasswordTextFormField(
      label: 'Obecne hasło',
      controller: controller,
      validator: (val) {
        if (val == '') {
          return 'To pole jest wymagane';
        }
        return null;
      },
      onChanged: (val) {
        isCorrectNotifier.value = val != '';
      },
    );
  }
}

class _NewPassword extends StatelessWidget {
  final TextEditingController controller;
  final ValueNotifier isCorrectNotifier;

  const _NewPassword({
    required this.controller,
    required this.isCorrectNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return PasswordTextFormField(
      label: 'Nowe hasło',
      controller: controller,
      validator: (val) {
        if (val == '') {
          return 'To pole jest wymagane';
        } else if (val != null && val.length < 6) {
          return 'Hasło musi zawierać co najmniej 6 znaków';
        }
        return null;
      },
      onChanged: (val) {
        isCorrectNotifier.value = val.length >= 6;
      },
    );
  }
}

class _NewPasswordConfirmation extends StatelessWidget {
  final TextEditingController controller;
  final ValueNotifier isCorrectNotifier;

  const _NewPasswordConfirmation({
    required this.controller,
    required this.isCorrectNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return PasswordTextFormField(
      label: 'Potwierdź hasło',
      controller: controller,
      validator: (val) {
        if (val == '') {
          return 'To pole jest wymagane';
        }
        return null;
      },
      onChanged: (val) {
        isCorrectNotifier.value = val.length >= 6;
      },
    );
  }
}

class _SubmitButton extends StatelessWidget {
  final TextEditingController currentPasswordController;
  final TextEditingController newPasswordController;
  final TextEditingController newPasswordConfirmationController;
  final ValueNotifier isCorrectCurrentPasswordNotifier;
  final ValueNotifier isCorrectNewPasswordNotifier;
  final ValueNotifier isCorrectNewPasswordConfirmationNotifier;

  const _SubmitButton({
    required this.currentPasswordController,
    required this.newPasswordController,
    required this.newPasswordConfirmationController,
    required this.isCorrectCurrentPasswordNotifier,
    required this.isCorrectNewPasswordNotifier,
    required this.isCorrectNewPasswordConfirmationNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isCorrectCurrentPasswordNotifier,
      builder: (_, isCorrectCurrentPassword, child) {
        return ValueListenableBuilder(
          valueListenable: isCorrectNewPasswordNotifier,
          builder: (_, isCorrectNewPassword, child) {
            return ValueListenableBuilder(
              valueListenable: isCorrectNewPasswordConfirmationNotifier,
              builder: (_, isCorrectNewPasswordConfirmation, child) {
                return MediumGreenButton(
                  text: 'Zapisz',
                  icon: Icons.check,
                  onPressed: isCorrectCurrentPassword == true &&
                          isCorrectNewPassword == true &&
                          isCorrectNewPasswordConfirmation == true
                      ? () async {
                          await _onClick(context);
                        }
                      : null,
                );
              },
            );
          },
        );
      },
    );
  }

  _onClick(BuildContext context) {
    String currentPassword = currentPasswordController.text;
    String newPassword = newPasswordController.text;
    String newPasswordConfirmation = newPasswordConfirmationController.text;
    if (newPassword != newPasswordConfirmation) {
      isCorrectNewPasswordConfirmationNotifier.value = false;
      _showNotTheSamePasswordsMessage();
    } else {
      Navigator.pop(
        context,
        PasswordDialogResult(
          currentPassword: currentPassword,
          newPassword: newPassword,
        ),
      );
    }
  }

  _showNotTheSamePasswordsMessage() {
    SnackBars.showSnackBar('Hasła nie są jednakowe!');
  }
}
