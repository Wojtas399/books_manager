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

  SettingsState copyWithInfo(SettingsBlocInfo info) {
    return copyWith(
      status: BlocStatusComplete<SettingsBlocInfo>(info: info),
    );
  }

  SettingsState copyWithError(SettingsBlocError error) {
    return copyWith(
      status: BlocStatusError<SettingsBlocError>(error: error),
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
