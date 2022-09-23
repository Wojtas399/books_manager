import 'dart:async';

import 'package:app/domain/entities/user.dart';
import 'package:app/domain/interfaces/auth_interface.dart';
import 'package:app/domain/interfaces/user_interface.dart';
import 'package:app/domain/use_cases/auth/get_logged_user_id_use_case.dart';
import 'package:app/domain/use_cases/user/get_user_use_case.dart';
import 'package:app/providers/theme_provider.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeUserSettingsListener extends StatefulWidget {
  final Widget child;

  const HomeUserSettingsListener({super.key, required this.child});

  @override
  State<HomeUserSettingsListener> createState() =>
      _HomeUserSettingsListenerState();
}

class _HomeUserSettingsListenerState extends State<HomeUserSettingsListener> {
  StreamSubscription<String?>? _loggedUserIdListener;
  StreamSubscription<User>? _userListener;

  @override
  void initState() {
    super.initState();

    _loggedUserIdListener ??=
        GetLoggedUserIdUseCase(authInterface: context.read<AuthInterface>())
            .execute()
            .listen(_manageLoggedUserId);
  }

  @override
  void dispose() {
    super.dispose();
    _loggedUserIdListener?.cancel();
    _userListener?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  void _manageLoggedUserId(String? loggedUserId) {
    if (loggedUserId != null) {
      _setUserListener(loggedUserId);
    }
  }

  void _setUserListener(String userId) {
    _userListener = GetUserUseCase(userInterface: context.read<UserInterface>())
        .execute(userId: userId)
        .listen(_manageUserThemeSettings);
  }

  void _manageUserThemeSettings(User user) {
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
