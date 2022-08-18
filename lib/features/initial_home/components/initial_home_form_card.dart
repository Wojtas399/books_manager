import 'package:flutter/widgets.dart';

import '../../../config/themes/app_colors.dart';
import '../../sign_in/sign_in_form.dart';

class InitialHomeFormCard extends StatelessWidget {
  const InitialHomeFormCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: AppColors.grey.withOpacity(0.2),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 4), // changes position of shadow
          ),
        ],
      ),
      child: const SignInForm(),
    );
  }
}
