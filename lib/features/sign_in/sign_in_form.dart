import 'package:app/features/sign_in/components/sign_in_form_content.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/sign_in_bloc.dart';

class SignInForm extends StatelessWidget {
  const SignInForm({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SignInBlocProvider(
      child: SignInFormContent(),
    );
  }
}

class _SignInBlocProvider extends StatelessWidget {
  final Widget child;

  const _SignInBlocProvider({required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SignInBloc(),
      child: child,
    );
  }
}
