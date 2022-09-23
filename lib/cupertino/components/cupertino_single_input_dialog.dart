import 'package:flutter/cupertino.dart';

class CupertinoSingleInputDialog extends StatelessWidget {
  final String title;
  final String? message;
  final String? placeholder;
  final String initialValue;
  final TextInputType? keyboardType;
  final bool obscureText;
  final String? acceptLabel;
  final String? cancelLabel;
  final TextEditingController _controller = TextEditingController();

  CupertinoSingleInputDialog({
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
    return CupertinoAlertDialog(
      title: Text(title),
      content: _Content(
        message: message,
        placeholder: placeholder,
        keyboardType: keyboardType,
        obscureText: obscureText,
        controller: _controller,
      ),
      actions: [
        CupertinoDialogAction(
          isDestructiveAction: true,
          child: Text(cancelLabel ?? 'Anuluj'),
          onPressed: () => _onCancelPressed(context),
        ),
        CupertinoDialogAction(
          child: Text(acceptLabel ?? 'Kontynuuj'),
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
      children: [
        SizedBox(height: message != null ? 4 : 0),
        Text(message ?? ''),
        SizedBox(height: message != null ? 16 : 0),
        CupertinoTextField(
          obscureText: obscureText,
          obscuringCharacter: '*',
          placeholder: placeholder,
          keyboardType: keyboardType,
          controller: controller,
          style: CupertinoTheme.of(context).textTheme.textStyle,
        ),
      ],
    );
  }
}
