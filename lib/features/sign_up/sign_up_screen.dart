import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/navigation.dart';
import '../../domain/use_cases/auth/sign_up_use_case.dart';
import '../../interfaces/auth_interface.dart';
import '../../interfaces/dialog_interface.dart';
import '../../interfaces/user_interface.dart';
import '../../models/bloc_status.dart';
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
        usernameValidator: UsernameValidator(),
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
    return BlocListener<SignUpBloc, SignUpState>(
      listener: (BuildContext context, SignUpState state) {
        final BlocStatus blocStatus = state.status;
        if (blocStatus is BlocStatusLoading) {
          _manageBlocLoadingStatus(context);
        } else if (blocStatus is BlocStatusComplete) {
          _manageBlocCompleteStatus(blocStatus, context);
        } else if (blocStatus is BlocStatusError) {
          _manageBlocErrorStatus(blocStatus, context);
        }
      },
      child: child,
    );
  }

  void _manageBlocLoadingStatus(BuildContext context) {
    context.read<DialogInterface>().showLoadingDialog(context: context);
  }

  void _manageBlocCompleteStatus(
    BlocStatusComplete completeStatus,
    BuildContext context,
  ) {
    context.read<DialogInterface>().closeLoadingDialog(context: context);
    final SignUpBlocInfo? blocInfo = completeStatus.info;
    if (blocInfo != null) {
      switch (blocInfo) {
        case SignUpBlocInfo.userHasBeenSignedUp:
          Navigation.navigateToHome(context: context);
          break;
      }
    }
  }

  void _manageBlocErrorStatus(
    BlocStatusError errorStatus,
    BuildContext context,
  ) {
    final DialogInterface dialogInterface = context.read<DialogInterface>();
    dialogInterface.closeLoadingDialog(context: context);
    final SignUpBlocError? blocError = errorStatus.error;
    if (blocError != null) {
      switch (blocError) {
        case SignUpBlocError.emailIsAlreadyTaken:
          dialogInterface.showInfoDialog(
            context: context,
            title: 'Zajęty email',
            info: 'Ten adres email jest już zajęty przez innego użytkownika.',
          );
          break;
      }
    }
  }
}
