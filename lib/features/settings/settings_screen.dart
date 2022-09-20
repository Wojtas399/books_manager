import 'package:app/components/custom_bloc_listener.dart';
import 'package:app/config/navigation.dart';
import 'package:app/domain/interfaces/auth_interface.dart';
import 'package:app/domain/interfaces/book_interface.dart';
import 'package:app/domain/interfaces/dialog_interface.dart';
import 'package:app/domain/interfaces/user_interface.dart';
import 'package:app/domain/use_cases/auth/delete_logged_user_use_case.dart';
import 'package:app/domain/use_cases/auth/sign_out_use_case.dart';
import 'package:app/features/settings/bloc/settings_bloc.dart';
import 'package:app/features/settings/components/settings_content.dart';
import 'package:app/providers/device_provider.dart';
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
        deleteLoggedUserUseCase: DeleteLoggedUserUseCase(
          device: DeviceProvider.provide(),
          bookInterface: context.read<BookInterface>(),
          userInterface: context.read<UserInterface>(),
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
    return CustomBlocListener<SettingsBloc, SettingsState, SettingsBlocInfo,
        SettingsBlocError>(
      onCompletionInfo: (SettingsBlocInfo blocInfo) => _manageSettingsBlocInfo(
        blocInfo,
        context,
      ),
      onError: (SettingsBlocError blocError) => _manageSettingsBlocError(
        blocError,
        context,
      ),
      child: child,
    );
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
