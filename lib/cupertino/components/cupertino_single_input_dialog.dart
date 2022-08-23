import 'package:flutter/cupertino.dart';

import 'cupertino_custom_text_field.dart';
import 'cupertino_password_text_field.dart';

class CupertinoSingleInputDialog extends StatelessWidget {
  final String title;
  final String? message;
  final String? placeholder;
  final bool obscureText;
  final TextEditingController _controller = TextEditingController();

  CupertinoSingleInputDialog({
    super.key,
    required this.title,
    this.message,
    this.placeholder,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(title),
      content: _Content(
        message: message,
        placeholder: placeholder,
        obscureText: obscureText,
        controller: _controller,
      ),
      actions: [
        CupertinoDialogAction(
          isDestructiveAction: true,
          child: const Text('Anuluj'),
          onPressed: () => _onCancelPressed(context),
        ),
        CupertinoDialogAction(
          child: const Text('Kontynuuj'),
          onPressed: () => _onContinuePressed(context),
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
      children: [
        SizedBox(height: message != null ? 4 : 0),
        Text(message ?? ''),
        const SizedBox(height: 16),
        obscureText
            ? CupertinoPasswordTextField(
                placeholder: placeholder,
                controller: controller,
              )
            : CupertinoCustomTextField(
                placeholder: placeholder,
                controller: controller,
              ),
      ],
    );
  }
}
