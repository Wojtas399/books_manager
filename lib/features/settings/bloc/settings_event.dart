part of 'settings_bloc.dart';

abstract class SettingsEvent {
  const SettingsEvent();
}

class SettingsEventSignOut extends SettingsEvent {
  const SettingsEventSignOut();
}

class SettingsEventDeleteAccount extends SettingsEvent {
  final String password;

  const SettingsEventDeleteAccount({required this.password});
}
