import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../config/themes/app_colors.dart';
import '../../../config/themes/text_theme.dart';
import '../../../interfaces/factories/icon_factory.dart';

class ResetPasswordDescription extends StatelessWidget {
  const ResetPasswordDescription({super.key});

  @override
  Widget build(BuildContext context) {
    final IconFactory iconFactory = context.read<IconFactory>();

    return Column(
      children: [
        iconFactory.createLockIcon(
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
