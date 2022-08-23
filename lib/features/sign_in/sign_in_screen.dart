import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/navigation.dart';
import '../../domain/use_cases/auth/get_auth_state_use_case.dart';
import '../../domain/use_cases/auth/sign_in_use_case.dart';
import '../../interfaces/auth_interface.dart';
import '../../interfaces/dialog_interface.dart';
import '../../models/bloc_status.dart';
import 'bloc/sign_in_bloc.dart';
import 'components/sign_in_content.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SignInBlocProvider(
      child: _SignInBlocListener(
        child: SignInContent(),
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
        getAuthStateUseCase: GetAuthStateUseCase(
          authInterface: context.read<AuthInterface>(),
        ),
        signInUseCase: SignInUseCase(
          authInterface: context.read<AuthInterface>(),
        ),
      )..add(SignInEventInitialize()),
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
    _closeLoadingDialog(context);
    final SignInBlocInfo? blocInfo = completeStatus.info;
    if (blocInfo != null) {
      _manageBlocInfo(blocInfo, context);
    }
  }

  void _manageBlocErrorStatus(
    BlocStatusError errorStatus,
    BuildContext context,
  ) {
    _closeLoadingDialog(context);
    final SignInBlocError? blocError = errorStatus.error;
    if (blocError != null) {
      _manageBlocError(blocError, context);
    }
  }

  void _closeLoadingDialog(BuildContext context) {
    context.read<DialogInterface>().closeLoadingDialog(context: context);
  }

  void _manageBlocInfo(SignInBlocInfo blocInfo, BuildContext context) {
    switch (blocInfo) {
      case SignInBlocInfo.userHasBeenSignedIn:
        _onUserSigningIn(context);
        break;
    }
  }

  void _manageBlocError(SignInBlocError blocError, BuildContext context) {
    switch (blocError) {
      case SignInBlocError.invalidEmail:
        _onInvalidEmail(context);
        break;
      case SignInBlocError.wrongPassword:
        _onWrongPassword(context);
        break;
      case SignInBlocError.userNotFound:
        _onLackOfUser(context);
        break;
      case SignInBlocError.noInternetConnection:
        _onLossOfInternetConnection(context);
        break;
      case SignInBlocError.timeoutException:
        _onTimeoutException(context);
        break;
    }
  }

  void _onUserSigningIn(BuildContext context) {
    Navigation.navigateToHome(context: context);
  }

  void _onInvalidEmail(BuildContext context) {
    context.read<DialogInterface>().showInfoDialog(
          context: context,
          title: 'Niepoprawny adres e-mail',
          info: 'Wprowadzony adres e-mail jest niepoprawny.',
        );
  }

  void _onWrongPassword(BuildContext context) {
    context.read<DialogInterface>().showInfoDialog(
          context: context,
          title: 'Błędne hasło',
          info: 'Podano błędne hasło dla tego użytkownika.',
        );
  }

  void _onLackOfUser(BuildContext context) {
    context.read<DialogInterface>().showInfoDialog(
          context: context,
          title: 'Brak użytkownika',
          info: 'Nie znaleziono użytkownika o podanym adresie e-mail.',
        );
  }

  void _onLossOfInternetConnection(BuildContext context) {
    context.read<DialogInterface>().showInfoDialog(
          context: context,
          title: 'Brak połączenia internetowego',
          info:
              'Nie można przeprowadzić operacji logowania, ponieważ nie masz połączenia internetowego...',
        );
  }

  void _onTimeoutException(BuildContext context) {
    context.read<DialogInterface>().showInfoDialog(
          context: context,
          title: 'Nieoczekiwany błąd...',
          info: 'Wystąpił nieoczekiwany błąd, spróbuj ponownie później.',
        );
  }
}
