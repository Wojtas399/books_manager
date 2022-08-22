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
    final DialogInterface dialogInterface = context.read<DialogInterface>();
    dialogInterface.closeLoadingDialog(context: context);
    final ResetPasswordBlocInfo? blocInfo = blocStatus.info;
    if (blocInfo != null) {
      switch (blocInfo) {
        case ResetPasswordBlocInfo.emailHasBeenSent:
          dialogInterface.showSnackbar(
            context: context,
            message: 'Pomyślnie wysłano wiadomość na podany adres email.',
          );
          break;
      }
    }
  }

  void _manageBlocErrorStatus(
    BlocStatusError blocStatus,
    BuildContext context,
  ) {
    final DialogInterface dialogInterface = context.read<DialogInterface>();
    dialogInterface.closeLoadingDialog(context: context);
    final ResetPasswordBlocError? blocError = blocStatus.error;
    if (blocError != null) {
      switch (blocError) {
        case ResetPasswordBlocError.userNotFound:
          dialogInterface.showInfoDialog(
            context: context,
            title: 'Brak użytkownika',
            info: 'Nie znaleziono użytkownika o podanym adresie email.',
          );
          break;
        case ResetPasswordBlocError.invalidEmail:
          dialogInterface.showInfoDialog(
            context: context,
            title: 'Niepoprawny adres email',
            info: 'Nie można wysłać wiadomości, ponieważ podany adres email jest niepoprawny.',
          );
          break;
      }
    }
  }
}
