import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../config/themes/app_colors.dart';
import '../../sign_in/sign_in_form.dart';
import '../../sign_up/sign_up_form.dart';
import '../bloc/initial_home_bloc.dart';

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
      child: const _Form(),
    );
  }
}

class _Form extends StatelessWidget {
  const _Form();

  @override
  Widget build(BuildContext context) {
    final InitialHomeMode mode = context.select(
      (InitialHomeBloc bloc) => bloc.state.mode,
    );
    switch (mode) {
      case InitialHomeMode.signIn:
        return const SignInForm();
      case InitialHomeMode.signUp:
        return const SignUpForm();
    }
  }
}
