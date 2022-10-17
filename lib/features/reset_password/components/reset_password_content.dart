import 'package:flutter/widgets.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../components/custom_scaffold_component.dart';
import '../../../components/on_tap_focus_lose_area_component.dart';
import 'reset_password_description.dart';
import 'reset_password_input.dart';
import 'reset_password_submit_button.dart';

class ResetPasswordContent extends StatelessWidget {
  const ResetPasswordContent({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarTitle: 'Resetowanie hasła',
      leadingIcon: MdiIcons.close,
      appBarWithElevation: false,
      body: OnTapFocusLoseAreaComponent(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: const [
                        ResetPasswordDescription(),
                        SizedBox(height: 32),
                        ResetPasswordInput(),
                      ],
                    ),
                  ),
                  const ResetPasswordSubmitButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
