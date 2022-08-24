import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ResetPasswordDescription extends StatelessWidget {
  const ResetPasswordDescription({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Icon(
          MdiIcons.lockOutline,
          size: 120,
          color: Colors.black,
        ),
        const SizedBox(height: 16),
        Text(
          'Nie pamiętasz hasła?',
          style: Theme.of(context).textTheme.headline5,
        ),
        const SizedBox(height: 16),
        Text(
          'Podaj adres email, na który wyślemy wiadomość z instrukcją dotyczącą resetowania hasła.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black.withOpacity(0.5),
          ),
        )
      ],
    );
  }
}
