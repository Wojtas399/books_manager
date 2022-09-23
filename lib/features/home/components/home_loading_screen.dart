import 'package:app/config/themes/app_colors.dart';
import 'package:flutter/material.dart';

class HomeLoadingScreen extends StatelessWidget {
  const HomeLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.lightBackground,
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          _Logo(),
          SizedBox(height: 16),
          _Info(),
          SizedBox(height: 20),
          _ProgressIndicator(),
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
      'Trwa ładowanie danych...',
      style: Theme.of(context).textTheme.headline6,
    );
  }
}

class _ProgressIndicator extends StatelessWidget {
  const _ProgressIndicator();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 46,
      height: 46,
      child: CircularProgressIndicator(
        strokeWidth: 8,
        backgroundColor: AppColors.primary.withOpacity(0.20),
      ),
    );
  }
}
