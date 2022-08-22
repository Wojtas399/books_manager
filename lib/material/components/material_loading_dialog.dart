import 'package:flutter/material.dart';

import '../../config/themes/app_colors.dart';

class MaterialLoadingDialog extends StatelessWidget {
  const MaterialLoadingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      contentPadding: const EdgeInsets.all(16.0),
      children: [
        Center(
          child: Column(
            children: [
              Text(
                'Ładowanie...',
                style: Theme.of(context).textTheme.subtitle1,
              ),
              const SizedBox(height: 16),
              CircularProgressIndicator(color: AppColors.primary),
            ],
          ),
        )
      ],
    );
  }
}
