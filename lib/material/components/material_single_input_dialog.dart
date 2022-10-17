import 'package:flutter/material.dart';

import '../../components/custom_text_field_component.dart';
import '../../components/password_text_field_component.dart';

class MaterialSingleInputDialog extends StatelessWidget {
  final String title;
  final String? message;
  final String? placeholder;
  final String initialValue;
  final TextInputType? keyboardType;
  final bool obscureText;
  final String? acceptLabel;
  final String? cancelLabel;
  final TextEditingController _controller = TextEditingController();

  MaterialSingleInputDialog({
    super.key,
    required this.title,
    this.message,
    this.placeholder,
    this.initialValue = '',
    this.keyboardType,
    this.obscureText = false,
    this.acceptLabel,
    this.cancelLabel,
  }) {
    _controller.text = initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      contentPadding: const EdgeInsets.only(
        top: 8,
        left: 24,
        right: 24,
      ),
      content: _Content(
        message: message,
        placeholder: placeholder,
        keyboardType: keyboardType,
        obscureText: obscureText,
        controller: _controller,
      ),
      actions: [
        TextButton(
          onPressed: () => _onCancelPressed(context),
          child: Text(cancelLabel ?? 'Anuluj'),
        ),
        TextButton(
          onPressed: () => _onContinuePressed(context),
          child: Text(acceptLabel ?? 'Kontynuuj'),
        ),
      ],
    );
  }

  void _onCancelPressed(BuildContext context) {
    Navigator.pop(context);
  }

  void _onContinuePressed(BuildContext context) {
    Navigator.pop(context, _controller.text);
  }
}

class _Content extends StatelessWidget {
  final String? message;
  final String? placeholder;
  final TextInputType? keyboardType;
  final bool obscureText;
  final TextEditingController controller;

  const _Content({
    this.message,
    this.placeholder,
    this.keyboardType,
    this.obscureText = false,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(message ?? ''),
        SizedBox(height: message != null ? 16 : 0),
        obscureText
            ? PasswordTextField(
                label: placeholder,
                keyboardType: keyboardType,
                controller: controller,
              )
            : CustomTextField(
                label: placeholder,
                keyboardType: keyboardType,
                controller: controller,
              ),
      ],
    );
  }
}
