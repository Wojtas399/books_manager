import 'package:app/components/custom_button_component.dart';
import 'package:app/components/custom_scaffold_component.dart';
import 'package:app/components/on_tap_focus_lose_area_component.dart';
import 'package:app/components/password_text_field_component.dart';
import 'package:app/validators/password_validator.dart';
import 'package:app/validators/validator_messages.dart';
import 'package:flutter/widgets.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class PasswordChangeComponent extends StatefulWidget {
  const PasswordChangeComponent({super.key});

  @override
  State<PasswordChangeComponent> createState() =>
      _PasswordChangeComponentState();
}

class _PasswordChangeComponentState extends State<PasswordChangeComponent> {
  final PasswordValidator _passwordValidator = PasswordValidator();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _newPasswordConfirmationController = TextEditingController();
  bool _areNewPasswordsTheSame = false;
  bool _isButtonDisabled = true;

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      leadingIcon: MdiIcons.close,
      appBarTitle: 'Zmiana hasła',
      body: SafeArea(
        child: OnTapFocusLoseAreaComponent(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      PasswordTextField(
                        label: 'Obecne hasło',
                        controller: _currentPasswordController,
                        onChanged: (_) => _onCurrentPasswordChanged(),
                      ),
                      const SizedBox(height: 16),
                      PasswordTextField(
                        label: 'Nowe hasło',
                        controller: _newPasswordController,
                        onChanged: (_) => _onNewPasswordsChanged(),
                        validator: _validateNewPassword,
                      ),
                      const SizedBox(height: 16),
                      PasswordTextField(
                        label: 'Powtórz nowe hasło',
                        controller: _newPasswordConfirmationController,
                        onChanged: (_) => _onNewPasswordsChanged(),
                        validator: _validateNewPasswordConfirmation,
                      ),
                    ],
                  ),
                  CustomButton(
                    label: 'Zapisz',
                    onPressed: _isButtonDisabled ? null : _onButtonPressed,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onCurrentPasswordChanged() {
    setState(() {
      _isButtonDisabled = _checkIfButtonIsDisabled();
    });
  }

  void _onNewPasswordsChanged() {
    final String newPassword = _newPasswordController.text;
    final String newPasswordConfirmation =
        _newPasswordConfirmationController.text;
    setState(() {
      _areNewPasswordsTheSame = newPassword == newPasswordConfirmation;
      _isButtonDisabled = _checkIfButtonIsDisabled();
    });
  }

  String? _validateNewPassword(String? newPassword) {
    if (newPassword != null && !_passwordValidator.isValid(newPassword)) {
      return ValidatorMessages.invalidPassword;
    }
    return null;
  }

  String? _validateNewPasswordConfirmation(String? newPasswordConfirmation) {
    if (!_areNewPasswordsTheSame) {
      return 'Hasła nie są jednakowe';
    }
    return null;
  }

  void _onButtonPressed() {
    Navigator.of(context).pop(
      PasswordChangeComponentReturnedValues(
        currentPassword: _currentPasswordController.text,
        newPassword: _newPasswordController.text,
      ),
    );
  }

  bool _checkIfButtonIsDisabled() {
    final String currentPassword = _currentPasswordController.text;
    final String newPassword = _newPasswordController.text;
    final String newPasswordConfirmation =
        _newPasswordConfirmationController.text;
    return currentPassword.isEmpty ||
        newPassword.isEmpty ||
        newPasswordConfirmation.isEmpty ||
        newPassword != newPasswordConfirmation;
  }
}

class PasswordChangeComponentReturnedValues {
  final String currentPassword;
  final String newPassword;

  const PasswordChangeComponentReturnedValues({
    required this.currentPassword,
    required this.newPassword,
  });
}
