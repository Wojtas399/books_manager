import 'package:flutter/cupertino.dart';

import '../../config/themes/app_colors.dart';
import '../../ui/errors_messages.dart';
import 'cupertino_text_field_background.dart';

class CupertinoPasswordTextField extends StatefulWidget {
  final String? placeholder;
  final Icon? icon;
  final Color? backgroundColor;
  final bool isRequired;
  final String? Function(String? value)? validator;
  final TextEditingController? controller;
  final Function(String)? onChanged;

  const CupertinoPasswordTextField({
    super.key,
    this.placeholder,
    this.icon,
    this.backgroundColor,
    this.isRequired = false,
    this.validator,
    this.controller,
    this.onChanged,
  });

  @override
  State<CupertinoPasswordTextField> createState() =>
      _CupertinoPasswordTextFieldState();
}

class _CupertinoPasswordTextFieldState
    extends State<CupertinoPasswordTextField> {
  bool isVisible = false;

  @override
  Widget build(BuildContext context) {
    return CupertinoTextFieldBackground(
      backgroundColor: widget.backgroundColor,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: CupertinoTextFormFieldRow(
              style: const TextStyle(color: CupertinoColors.black),
              placeholder: widget.placeholder,
              prefix: widget.icon,
              padding: const EdgeInsets.all(8),
              obscureText: !isVisible,
              obscuringCharacter: '*',
              placeholderStyle: TextStyle(color: AppColors.grey),
              validator: _validate,
              controller: widget.controller,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onChanged: widget.onChanged,
            ),
          ),
          CupertinoButton(
            onPressed: _onVisibilityIconPressed,
            padding: const EdgeInsets.only(right: 8),
            child: Icon(
              isVisible ? CupertinoIcons.eye_slash : CupertinoIcons.eye,
            ),
          ),
        ],
      ),
    );
  }

  void _onVisibilityIconPressed() {
    setState(() {
      isVisible = !isVisible;
    });
  }

  String? _validate(String? value) {
    if (widget.isRequired && value == '') {
      return ErrorsMessages.requiredValue;
    }
    final String? Function(String? value)? customValidator = widget.validator;
    if (customValidator != null) {
      return customValidator(value);
    }
    return null;
  }
}
