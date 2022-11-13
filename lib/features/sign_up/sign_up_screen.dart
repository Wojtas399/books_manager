import 'package:app/components/bloc_listener_component.dart';
import 'package:app/domain/interfaces/auth_interface.dart';
import 'package:app/domain/interfaces/user_interface.dart';
import 'package:app/domain/use_cases/auth/sign_up_use_case.dart';
import 'package:app/extensions/dialogs_build_context_extension.dart';
import 'package:app/extensions/navigator_build_context_extension.dart';
import 'package:app/features/sign_up/bloc/sign_up_bloc.dart';
import 'package:app/features/sign_up/components/sign_up_content.dart';
import 'package:app/validators/email_validator.dart';
import 'package:app/validators/password_validator.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SignUpBlocProvider(
      child: _SignUpBlocListener(
        child: SignUpContent(),
      ),
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
        emailValidator: EmailValidator(),
        passwordValidator: PasswordValidator(),
        signUpUseCase: SignUpUseCase(
          authInterface: context.read<AuthInterface>(),
          userInterface: context.read<UserInterface>(),
        ),
      ),
      child: child,
    );
  }
}

class _SignUpBlocListener extends StatelessWidget {
  final Widget child;

  const _SignUpBlocListener({required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocListenerComponent<SignUpBloc, SignUpState, SignUpBlocInfo,
        SignUpBlocError>(
      onCompletionInfo: (SignUpBlocInfo info) => _manageBlocInfo(info, context),
      onError: (SignUpBlocError error) => _manageBlocError(error, context),
      child: child,
    );
  }

  void _manageBlocInfo(SignUpBlocInfo blocInfo, BuildContext context) {
    switch (blocInfo) {
      case SignUpBlocInfo.userHasBeenSignedUp:
        _onUserSigningUp(context);
        break;
    }
  }

  void _manageBlocError(SignUpBlocError blocError, BuildContext context) {
    switch (blocError) {
      case SignUpBlocError.emailIsAlreadyTaken:
        _emailIsAlreadyTakenInfo(context);
        break;
    }
  }

  void _onUserSigningUp(BuildContext context) {
    context.navigateToHome();
  }

  void _emailIsAlreadyTakenInfo(BuildContext context) {
    context.showInfoDialog(
      title: 'Zajęty email',
      info: 'Ten adres email jest już zajęty przez innego użytkownika.',
    );
  }
}
