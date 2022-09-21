part of 'settings_bloc.dart';

abstract class SettingsEvent {
  const SettingsEvent();
}

class SettingsEventInitialize extends SettingsEvent {
  const SettingsEventInitialize();
}

class SettingsEventUserUpdated extends SettingsEvent {
  final User user;

  const SettingsEventUserUpdated({required this.user});
}

class SettingsEventSwitchDarkMode extends SettingsEvent {
  final bool isSwitched;

  const SettingsEventSwitchDarkMode({required this.isSwitched});
}

class SettingsEventSwitchDarkModeCompatibilityWithSystem extends SettingsEvent {
  final bool isSwitched;

  const SettingsEventSwitchDarkModeCompatibilityWithSystem({
    required this.isSwitched,
  });
}

class SettingsEventChangePassword extends SettingsEvent {
  final String currentPassword;
  final String newPassword;

  const SettingsEventChangePassword({
    required this.currentPassword,
    required this.newPassword,
  });
}

class SettingsEventSignOut extends SettingsEvent {
  const SettingsEventSignOut();
}

class SettingsEventDeleteAccount extends SettingsEvent {
  final String password;

  const SettingsEventDeleteAccount({required this.password});
}
