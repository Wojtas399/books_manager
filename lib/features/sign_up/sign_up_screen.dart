import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../validators/email_validator.dart';
import '../../validators/password_validator.dart';
import '../../validators/username_validator.dart';
import 'bloc/sign_up_bloc.dart';
import 'components/sign_up_content.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SignUpBlocProvider(
      child: SignUpContent(),
    );
  }
}

class _SignUpBlocProvider extends StatelessWidget {
  final Widget child;

  const _SignUpBlocProvider({required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SignUpBloc(
        usernameValidator: UsernameValidator(),
        emailValidator: EmailValidator(),
        passwordValidator: PasswordValidator(),
      ),
      child: child,
    );
  }
}
