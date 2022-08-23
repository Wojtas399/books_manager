import 'package:flutter/material.dart';

import 'material_custom_text_field.dart';
import 'material_password_text_field.dart';

class MaterialSingleInputDialog extends StatelessWidget {
  final String title;
  final String? message;
  final String? placeholder;
  final bool obscureText;
  final TextEditingController _controller = TextEditingController();

  MaterialSingleInputDialog({
    super.key,
    required this.title,
    this.message,
    this.placeholder,
    this.obscureText = false,
  });

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
        obscureText: obscureText,
        controller: _controller,
      ),
      actions: [
        TextButton(
          onPressed: () => _onCancelPressed(context),
          child: const Text('Anuluj'),
        ),
        TextButton(
          onPressed: () => _onContinuePressed(context),
          child: const Text('Kontynuuj'),
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
  final bool obscureText;
  final TextEditingController controller;

  const _Content({
    required this.message,
    required this.placeholder,
    required this.obscureText,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(message ?? ''),
        const SizedBox(height: 16),
        obscureText
            ? MaterialPasswordTextField(
                placeholder: placeholder,
                controller: controller,
              )
            : MaterialCustomTextField(
                placeholder: placeholder,
                controller: controller,
              ),
      ],
    );
  }
}
