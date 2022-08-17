import 'package:flutter/cupertino.dart';

import '../config/themes/app_colors.dart';
import 'cupertino_text_field_background.dart';

class CupertinoPasswordTextField extends StatefulWidget {
  final String? placeholder;
  final Icon? icon;
  final Color? backgroundColor;

  const CupertinoPasswordTextField({
    super.key,
    this.placeholder,
    this.icon,
    this.backgroundColor,
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
          Flexible(
            child: CupertinoTextFormFieldRow(
              placeholder: widget.placeholder,
              prefix: widget.icon,
              padding: const EdgeInsets.all(10),
              obscureText: !isVisible,
              obscuringCharacter: '*',
              placeholderStyle: TextStyle(color: AppColors.grey),
            ),
          ),
          CupertinoButton(
            onPressed: _onVisibilityIconPressed,
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
}
