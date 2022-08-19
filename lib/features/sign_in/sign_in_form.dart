import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/navigation.dart';
import '../../domain/use_cases/auth/sign_in_use_case.dart';
import '../../interfaces/auth_interface.dart';
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
      listener: (_, SignInState state) {
        final BlocStatus blocStatus = state.status;
        if (blocStatus is BlocStatusComplete) {
          final SignInBlocInfo? blocInfo = blocStatus.info;
          if (blocInfo != null) {
            _manageBlocInfo(blocInfo, context);
          }
        } else if (blocStatus is BlocStatusError) {
          final SignInBlocError? blocError = blocStatus.error;
          if (blocError != null) {
            _manageBlocError(blocError, context);
          }
        }
      },
      child: child,
    );
  }

  void _manageBlocInfo(SignInBlocInfo blocInfo, BuildContext context) {
    switch (blocInfo) {
      case SignInBlocInfo.userHasBeenSignedIn:
        Navigation.navigateToHome(context: context);
        break;
    }
  }

  void _manageBlocError(SignInBlocError blocError, BuildContext context) {
    switch (blocError) {
      case SignInBlocError.invalidEmail:
        // TODO: Handle this case.
        break;
      case SignInBlocError.invalidPassword:
        // TODO: Handle this case.
        break;
      case SignInBlocError.userNotFound:
        // TODO: Handle this case.
        break;
    }
  }
}
