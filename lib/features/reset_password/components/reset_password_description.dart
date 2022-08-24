import 'package:flutter/widgets.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../config/themes/app_colors.dart';
import '../../../config/themes/text_theme.dart';

class ResetPasswordDescription extends StatelessWidget {
  const ResetPasswordDescription({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          MdiIcons.lockOutline,
          size: 120,
          color: AppColors.black,
        ),
        const SizedBox(height: 16),
        Text('Nie pamiętasz hasła?', style: TextTheme.titleMedium),
        const SizedBox(height: 16),
        Text(
          'Podaj adres email, na który wyślemy wiadomość z instrukcją dotyczącą resetowania hasła.',
          textAlign: TextAlign.center,
          style: TextTheme.greyText,
        )
      ],
    );
  }
}
