import 'package:flutter/material.dart';

import '../../../config/themes/app_colors.dart';

class HomeLoadingScreen extends StatelessWidget {
  const HomeLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          _Logo(),
          SizedBox(height: 32),
          _Info(),
          SizedBox(height: 16),
          LinearProgressIndicator(minHeight: 10),
        ],
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo();

  @override
  Widget build(BuildContext context) {
    return Image.asset('assets/images/Logo.png');
  }
}

class _Info extends StatelessWidget {
  const _Info();

  @override
  Widget build(BuildContext context) {
    return Text(
      'Trwa ładowanie...',
      style: Theme.of(context).textTheme.headline6,
    );
  }
}
