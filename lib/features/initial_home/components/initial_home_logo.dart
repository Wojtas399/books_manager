import 'package:flutter/widgets.dart';

class InitialHomeLogo extends StatelessWidget {
  const InitialHomeLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Image.asset('assets/images/Logo.png'),
    );
  }
}