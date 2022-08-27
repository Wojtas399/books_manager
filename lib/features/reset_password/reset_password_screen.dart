import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/use_cases/auth/send_reset_password_email_use_case.dart';
import '../../interfaces/auth_interface.dart';
import '../../interfaces/dialog_interface.dart';
import '../../models/bloc_status.dart';
import 'bloc/reset_password_bloc.dart';
import 'components/reset_password_content.dart';

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
    return BlocListener<ResetPasswordBloc, ResetPasswordState>(
      listener: (BuildContext context, ResetPasswordState state) {
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
    BlocStatusComplete blocStatus,
    BuildContext context,
  ) {
    _closeLoadingDialog(context);
    final ResetPasswordBlocInfo? blocInfo = blocStatus.info;
    if (blocInfo != null) {
      _manageBlocInfo(blocInfo, context);
    }
  }

  void _manageBlocErrorStatus(
    BlocStatusError blocStatus,
    BuildContext context,
  ) {
    _closeLoadingDialog(context);
    final ResetPasswordBlocError? blocError = blocStatus.error;
    if (blocError != null) {
      _manageBlocError(blocError, context);
    }
  }

  void _closeLoadingDialog(BuildContext context) {
    context.read<DialogInterface>().closeLoadingDialog(context: context);
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
      case ResetPasswordBlocError.lossOfConnection:
        _lossOfConnectionInfo(context);
        break;
      case ResetPasswordBlocError.timeoutException:
        _timeoutInfo(context);
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

  void _lossOfConnectionInfo(BuildContext context) {
    context.read<DialogInterface>().showLossOfConnectionDialog(
          context: context,
        );
  }

  void _timeoutInfo(BuildContext context) {
    context.read<DialogInterface>().showTimeoutDialog(context: context);
  }
}
