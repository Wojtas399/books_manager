part of 'settings_bloc.dart';

class SettingsState extends BlocState {
  final bool isDarkModeOn;
  final bool isDarkModeCompatibilityWithSystemOn;

  const SettingsState({
    required super.status,
    required this.isDarkModeOn,
    required this.isDarkModeCompatibilityWithSystemOn,
  });

  @override
  List<Object> get props => [
        status,
        isDarkModeOn,
        isDarkModeCompatibilityWithSystemOn,
      ];

  @override
  SettingsState copyWith({
    BlocStatus? status,
    bool? isDarkModeOn,
    bool? isDarkModeCompatibilityWithSystemOn,
  }) {
    return SettingsState(
      status: status ?? const BlocStatusInProgress(),
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
