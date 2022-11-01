import 'package:app/components/bloc_listener_component.dart';
import 'package:app/config/navigation.dart';
import 'package:app/domain/interfaces/auth_interface.dart';
import 'package:app/domain/interfaces/dialog_interface.dart';
import 'package:app/domain/use_cases/auth/get_logged_user_id_use_case.dart';
import 'package:app/domain/use_cases/auth/sign_in_use_case.dart';
import 'package:app/features/sign_in/bloc/sign_in_bloc.dart';
import 'package:app/features/sign_in/components/sign_in_content.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        getLoggedUserIdUseCase: GetLoggedUserIdUseCase(
          authInterface: context.read<AuthInterface>(),
        ),
        signInUseCase: SignInUseCase(
          authInterface: context.read<AuthInterface>(),
        ),
      )..add(const SignInEventInitialize()),
      child: child,
    );
  }
}

class _SignInBlocListener extends StatelessWidget {
  final Widget child;

  const _SignInBlocListener({required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocListenerComponent<SignInBloc, SignInState, SignInBlocInfo,
        SignInBlocError>(
      onCompletionInfo: (SignInBlocInfo info) => _manageBlocInfo(info, context),
      onError: (SignInBlocError error) => _manageBlocError(error, context),
      child: child,
    );
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
        _invalidEmailInfo(context);
        break;
      case SignInBlocError.wrongPassword:
        _wrongPasswordInfo(context);
        break;
      case SignInBlocError.userNotFound:
        _noUserFoundInfo(context);
        break;
    }
  }

  void _onUserSigningIn(BuildContext context) {
    Navigation.navigateToHome(context: context);
  }

  void _invalidEmailInfo(BuildContext context) {
    context.read<DialogInterface>().showInfoDialog(
          context: context,
          title: 'Niepoprawny adres e-mail',
          info: 'Wprowadzony adres e-mail jest niepoprawny.',
        );
  }

  void _wrongPasswordInfo(BuildContext context) {
    context.read<DialogInterface>().showInfoDialog(
          context: context,
          title: 'Błędne hasło',
          info: 'Podano błędne hasło dla tego użytkownika.',
        );
  }

  void _noUserFoundInfo(BuildContext context) {
    context.read<DialogInterface>().showInfoDialog(
          context: context,
          title: 'Brak użytkownika',
          info: 'Nie znaleziono użytkownika o podanym adresie e-mail.',
        );
  }
}
