import 'package:app/components/bloc_listener_component.dart';
import 'package:app/domain/interfaces/auth_interface.dart';
import 'package:app/domain/interfaces/dialog_interface.dart';
import 'package:app/domain/use_cases/auth/send_reset_password_email_use_case.dart';
import 'package:app/features/reset_password/bloc/reset_password_bloc.dart';
import 'package:app/features/reset_password/components/reset_password_content.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _ResetPasswordBlocProvider(
      child: _ResetPasswordBlocListener(
        child: ResetPasswordContent(),
      ),
    );
  }
}

class _ResetPasswordBlocProvider extends StatelessWidget {
  final Widget child;

  const _ResetPasswordBlocProvider({required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ResetPasswordBloc(
        sendResetPasswordEmailUseCase: SendResetPasswordEmailUseCase(
          authInterface: context.read<AuthInterface>(),
        ),
      ),
      child: child,
    );
  }
}

class _ResetPasswordBlocListener extends StatelessWidget {
  final Widget child;

  const _ResetPasswordBlocListener({required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocListenerComponent<ResetPasswordBloc, ResetPasswordState,
        ResetPasswordBlocInfo, ResetPasswordBlocError>(
      onCompletionInfo: (ResetPasswordBlocInfo info) => _manageBlocInfo(
        info,
        context,
      ),
      onError: (ResetPasswordBlocError error) => _manageBlocError(
        error,
        context,
      ),
      child: child,
    );
  }

  void _manageBlocInfo(
    ResetPasswordBlocInfo blocInfo,
    BuildContext context,
  ) {
    switch (blocInfo) {
      case ResetPasswordBlocInfo.emailHasBeenSent:
        _emailHasBeenSentInfo(context);
        break;
    }
  }

  void _manageBlocError(
    ResetPasswordBlocError blocError,
    BuildContext context,
  ) {
    switch (blocError) {
      case ResetPasswordBlocError.userNotFound:
        _userNotFoundInfo(context);
        break;
      case ResetPasswordBlocError.invalidEmail:
        _invalidEmailInfo(context);
        break;
    }
  }

  void _emailHasBeenSentInfo(BuildContext context) {
    context.read<DialogInterface>().showSnackBar(
          context: context,
          message: 'Pomyślnie wysłano wiadomość na podany adres email.',
        );
  }

  void _userNotFoundInfo(BuildContext context) {
    context.read<DialogInterface>().showInfoDialog(
          context: context,
          title: 'Brak użytkownika',
          info: 'Nie znaleziono użytkownika o podanym adresie email.',
        );
  }

  void _invalidEmailInfo(BuildContext context) {
    context.read<DialogInterface>().showInfoDialog(
          context: context,
          title: 'Niepoprawny adres email',
          info:
              'Nie można wysłać wiadomości, ponieważ podany adres email jest niepoprawny.',
        );
  }
}
