import 'package:app/constants/theme.dart';
import 'package:app/widgets/buttons/small_green_button.dart';
import 'package:app/widgets/buttons/small_red_button.dart';
import 'package:app/widgets/text_fields/basic_text_form_field.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class SingleInputDialog extends StatelessWidget {
  final String title;
  final String? label;
  final TextInputType? type;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  late final String? originalValue;

  SingleInputDialog({
    required this.title,
    required this.controller,
    this.type,
    this.label,
    this.validator,
  }) {
    this.originalValue = this.controller.text;
  }

  @override
  Widget build(BuildContext context) {
    ValueNotifier<bool> isButtonDisabled = ValueNotifier<bool>(true);

    return AlertDialog(
      title: Text(title),
      backgroundColor: HexColor(AppColors.LIGHT_BLUE),
      content: Container(
        child: _Input(
          type: type,
          originalValue: originalValue,
          label: label,
          controller: controller,
          validator: validator,
          isButtonDisabled: isButtonDisabled,
        ),
      ),
      actions: [
        SmallRedButton(
          text: 'Anuluj',
          icon: Icons.close,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        _SubmitButton(
          isDisabled: isButtonDisabled,
          inputController: controller,
        )
      ],
    );
  }
}

class _Input extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final String? label;
  final String? originalValue;
  final TextInputType? type;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final ValueNotifier<bool> isButtonDisabled;

  _Input({
    required this.label,
    required this.originalValue,
    required this.type,
    required this.controller,
    required this.validator,
    required this.isButtonDisabled,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: BasicTextFormField(
        type: type,
        label: label ?? '',
        controller: controller,
        validator: validator,
        onChanged: (val) {
          if (val == originalValue) {
            isButtonDisabled.value = true;
          } else {
            isButtonDisabled.value = _checkIfTextFormValueIsCorrect(val);
          }
        },
      ),
    );
  }

  bool _checkIfTextFormValueIsCorrect(String value) {
    FormState? formState = _formKey.currentState;
    if (formState != null) {
      return !formState.validate();
    }
    return true;
  }
}

class _SubmitButton extends StatelessWidget {
  final ValueNotifier<bool> isDisabled;
  final TextEditingController inputController;

  const _SubmitButton({
    required this.isDisabled,
    required this.inputController,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isDisabled,
      builder: (_, bool disabled, child) {
        return SmallGreenButton(
          text: 'Zapisz',
          icon: Icons.check,
          onPressed: !disabled
              ? () {
                  Navigator.pop(context, inputController.text);
                }
              : null,
        );
      },
    );
  }
}
