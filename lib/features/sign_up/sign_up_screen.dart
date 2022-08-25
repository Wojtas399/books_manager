import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/navigation.dart';
import '../../domain/use_cases/auth/sign_up_use_case.dart';
import '../../interfaces/auth_interface.dart';
import '../../interfaces/dialog_interface.dart';
import '../../models/bloc_status.dart';
import '../../validators/email_validator.dart';
import '../../validators/password_validator.dart';
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
        emailValidator: EmailValidator(),
        passwordValidator: PasswordValidator(),
        signUpUseCase: SignUpUseCase(
          authInterface: context.read<AuthInterface>(),
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
    _closeLoadingDialog(context);
    final SignUpBlocInfo? blocInfo = completeStatus.info;
    if (blocInfo != null) {
      _manageBlocInfo(blocInfo, context);
    }
  }

  void _manageBlocErrorStatus(
    BlocStatusError errorStatus,
    BuildContext context,
  ) {
    _closeLoadingDialog(context);
    final SignUpBlocError? blocError = errorStatus.error;
    if (blocError != null) {
      _manageBlocError(blocError, context);
    }
  }

  void _closeLoadingDialog(BuildContext context) {
    context.read<DialogInterface>().closeLoadingDialog(context: context);
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
      case SignUpBlocError.lossOfConnection:
        _lossOfConnectionInfo(context);
        break;
      case SignUpBlocError.loadingTimeExceeded:
        _loadingTimeExceededInfo(context);
        break;
    }
  }

  void _onUserSigningUp(BuildContext context) {
    Navigation.navigateToHome(context: context);
  }

  void _emailIsAlreadyTakenInfo(BuildContext context) {
    context.read<DialogInterface>().showInfoDialog(
          context: context,
          title: 'Zajęty email',
          info: 'Ten adres email jest już zajęty przez innego użytkownika.',
        );
  }

  void _lossOfConnectionInfo(BuildContext context) {
    context.read<DialogInterface>().showLossOfConnectionDialog(
          context: context,
        );
  }

  void _loadingTimeExceededInfo(BuildContext context) {
    context.read<DialogInterface>().showTimeoutDialog(context: context);
  }
}
