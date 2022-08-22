import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../components/on_tap_focus_lose_area_component.dart';
import '../../../config/themes/app_colors.dart';
import '../../../interfaces/factories/icon_factory.dart';
import '../../../interfaces/factories/widget_factory.dart';
import 'reset_password_description.dart';
import 'reset_password_input.dart';
import 'reset_password_submit_button.dart';

class ResetPasswordContent extends StatelessWidget {
  const ResetPasswordContent({super.key});

  @override
  Widget build(BuildContext context) {
    final WidgetFactory widgetFactory = context.read<WidgetFactory>();
    final IconFactory iconFactory = context.read<IconFactory>();

    return widgetFactory.createScaffold(
      leadingIcon: iconFactory.createCloseIcon(),
      appBarTitle: 'Resetowanie hasła',
      appBarBackgroundColor: AppColors.background,
      appBarWithElevation: false,
      child: OnTapFocusLoseAreaComponent(
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
