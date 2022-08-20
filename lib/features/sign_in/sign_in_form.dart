import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/navigation.dart';
import '../../domain/use_cases/auth/sign_in_use_case.dart';
import '../../interfaces/auth_interface.dart';
import '../../interfaces/dialog_interface.dart';
import '../../models/bloc_status.dart';
import 'bloc/sign_in_bloc.dart';
import 'components/sign_in_form_content.dart';

class SignInForm extends StatelessWidget {
  const SignInForm({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SignInBlocProvider(
      child: _SignInBlocListener(
        child: SignInFormContent(),
      ),
    );
  }
}

class _SignInBlocProvider extends StatelessWidget {
  final Widget child;

  const _SignInBlocProvider({required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SignInBloc(
        signInUseCase: SignInUseCase(
          authInterface: context.read<AuthInterface>(),
        ),
      ),
      child: child,
    );
  }
}

class _SignInBlocListener extends StatelessWidget {
  final Widget child;

  const _SignInBlocListener({required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignInBloc, SignInState>(
      listener: (BuildContext context, SignInState state) {
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
    final SignInBlocInfo? blocInfo = completeStatus.info;
    if (blocInfo != null) {
      _manageBlocInfo(blocInfo, context);
    }
  }

  void _manageBlocErrorStatus(
    BlocStatusError errorStatus,
    BuildContext context,
  ) {
    context.read<DialogInterface>().closeLoadingDialog(context: context);
    final SignInBlocError? blocError = errorStatus.error;
    if (blocError != null) {
      _manageBlocErrorType(blocError, context);
    }
  }

  void _manageBlocInfo(SignInBlocInfo blocInfo, BuildContext context) {
    switch (blocInfo) {
      case SignInBlocInfo.userHasBeenSignedIn:
        Navigation.navigateToHome(context: context);
        break;
    }
  }

  void _manageBlocErrorType(
    SignInBlocError blocError,
    BuildContext context,
  ) {
    final DialogInterface dialogInterface = context.read<DialogInterface>();
    switch (blocError) {
      case SignInBlocError.invalidEmail:
        dialogInterface.showInfoDialog(
          context: context,
          title: 'Niepoprawny adres e-mail',
          info: 'Wprowadzony adres e-mail jest niepoprawny.',
        );
        break;
      case SignInBlocError.wrongPassword:
        dialogInterface.showInfoDialog(
          context: context,
          title: 'Błędne hasło',
          info: 'Podano błędne hasło dla tego użytkownika.',
        );
        break;
      case SignInBlocError.userNotFound:
        dialogInterface.showInfoDialog(
          context: context,
          title: 'Brak użytkownika',
          info: 'Nie znaleziono użytkownika o podanym adresie e-mail.',
        );
        break;
    }
  }
}
