import 'dart:async';

import 'package:app/domain/entities/user.dart';
import 'package:app/domain/interfaces/auth_interface.dart';
import 'package:app/domain/interfaces/user_interface.dart';
import 'package:app/domain/use_cases/auth/get_logged_user_id_use_case.dart';
import 'package:app/domain/use_cases/user/get_user_use_case.dart';
import 'package:app/providers/theme_provider.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

class HomeUserSettingsListener extends StatefulWidget {
  final Widget child;

  const HomeUserSettingsListener({super.key, required this.child});

  @override
  State<HomeUserSettingsListener> createState() =>
      _HomeUserSettingsListenerState();
}

class _HomeUserSettingsListenerState extends State<HomeUserSettingsListener> {
  StreamSubscription<User?>? _userListener;

  @override
  void initState() {
    super.initState();

    _userListener =
        GetLoggedUserIdUseCase(authInterface: context.read<AuthInterface>())
            .execute()
            .switchMap(_getUser)
            .listen(_manageUserThemeSettings);
  }

  @override
  void dispose() {
    _userListener?.cancel();
    return super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  Stream<User?> _getUser(String? loggedUserId) {
    if (loggedUserId == null) {
      return Stream.value(null);
    }
    return GetUserUseCase(
      userInterface: context.read<UserInterface>(),
    ).execute(userId: loggedUserId);
  }

  void _manageUserThemeSettings(User? user) {
    if (user == null) {
      return;
    }
    final ThemeProvider themeProvider = context.read<ThemeProvider>();
    if (user.isDarkModeCompatibilityWithSystemOn) {
      themeProvider.turnOnSystemTheme();
    } else if (user.isDarkModeOn) {
      themeProvider.turnOnDarkTheme();
    } else {
      themeProvider.turnOnLightTheme();
    }
  }
}
