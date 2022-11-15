part of 'settings_bloc.dart';

class SettingsState extends BlocState {
  final String? loggedUserEmail;
  final bool isDarkModeOn;
  final bool isDarkModeCompatibilityWithSystemOn;

  const SettingsState({
    required super.status,
    required this.loggedUserEmail,
    required this.isDarkModeOn,
    required this.isDarkModeCompatibilityWithSystemOn,
  });

  @override
  List<Object> get props => [
        status,
        loggedUserEmail ?? '',
        isDarkModeOn,
        isDarkModeCompatibilityWithSystemOn,
      ];

  @override
  SettingsState copyWith({
    BlocStatus? status,
    String? loggedUserEmail,
    bool? isDarkModeOn,
    bool? isDarkModeCompatibilityWithSystemOn,
  }) {
    return SettingsState(
      status: status ?? const BlocStatusComplete(),
      loggedUserEmail: loggedUserEmail ?? this.loggedUserEmail,
      isDarkModeOn: isDarkModeOn ?? this.isDarkModeOn,
      isDarkModeCompatibilityWithSystemOn:
          isDarkModeCompatibilityWithSystemOn ??
              this.isDarkModeCompatibilityWithSystemOn,
    );
  }
}

enum SettingsBlocInfo {
  passwordHasBeenChanged,
  userHasBeenSignedOut,
  userAccountHasBeenDeleted,
}

enum SettingsBlocError {
  wrongPassword,
}
