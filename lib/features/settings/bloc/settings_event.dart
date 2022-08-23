part of 'settings_bloc.dart';

abstract class SettingsEvent {}

class SettingsEventSignOut extends SettingsEvent {}

class SettingsEventDeleteAccount extends SettingsEvent {
  final String password;

  SettingsEventDeleteAccount({required this.password});
}
