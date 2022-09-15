import 'package:app/config/navigation.dart';
import 'package:app/domain/interfaces/auth_interface.dart';
import 'package:app/domain/interfaces/dialog_interface.dart';
import 'package:app/domain/use_cases/auth/delete_user_use_case.dart';
import 'package:app/domain/use_cases/auth/sign_out_use_case.dart';
import 'package:app/features/settings/bloc/settings_bloc.dart';
import 'package:app/features/settings/components/settings_content.dart';
import 'package:app/models/bloc_status.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SettingsBlocProvider(
      child: _SettingsBlocListener(
        child: SettingsContent(),
      ),
    );
  }
}

class _SettingsBlocProvider extends StatelessWidget {
  final Widget child;

  const _SettingsBlocProvider({required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SettingsBloc(
        signOutUseCase: SignOutUseCase(
          authInterface: context.read<AuthInterface>(),
        ),
        deleteUserUseCase: DeleteUserUseCase(
          authInterface: context.read<AuthInterface>(),
        ),
      ),
      child: child,
    );
  }
}

class _SettingsBlocListener extends StatelessWidget {
  final Widget child;

  const _SettingsBlocListener({required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SettingsBloc, SettingsState>(
      listener: (BuildContext context, SettingsState state) {
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
    final SettingsBlocInfo? blocInfo = completeStatus.info;
    if (blocInfo != null) {
      _manageSettingsBlocInfo(blocInfo, context);
    }
  }

  void _manageBlocErrorStatus(
    BlocStatusError errorStatus,
    BuildContext context,
  ) {
    context.read<DialogInterface>().closeLoadingDialog(context: context);
    final SettingsBlocError? blocError = errorStatus.error;
    if (blocError != null) {
      _manageSettingsBlocError(blocError, context);
    }
  }

  void _manageSettingsBlocInfo(
    SettingsBlocInfo blocInfo,
    BuildContext context,
  ) {
    switch (blocInfo) {
      case SettingsBlocInfo.userHasBeenSignedOut:
        _onUserSigningOut();
        break;
      case SettingsBlocInfo.userAccountHasBeenDeleted:
        _onUserAccountDeletion(context);
        break;
    }
  }

  void _manageSettingsBlocError(
    SettingsBlocError blocError,
    BuildContext context,
  ) {
    switch (blocError) {
      case SettingsBlocError.wrongPassword:
        _wrongPasswordInfo(context);
        break;
    }
  }

  void _onUserSigningOut() {
    Navigation.navigateToSignInScreen();
  }

  void _onUserAccountDeletion(BuildContext context) {
    Navigation.navigateToSignInScreen();
    _accountDeletionInfo(context);
  }

  void _accountDeletionInfo(BuildContext context) {
    context.read<DialogInterface>().showInfoDialog(
          context: context,
          title: 'Pomyślne usunięcie konta',
          info:
              'Twoje konto zostało pomyślnie usunięte. Aby skorzystać ponownie z aplikacji załóż nowe konto.',
        );
  }

  void _wrongPasswordInfo(BuildContext context) {
    context.read<DialogInterface>().showInfoDialog(
          context: context,
          title: 'Błędne hasło',
          info:
              'Nie można przeprowadzić operacji usuwania konta, ponieważ podane hasło jest błędne.',
        );
  }
}
