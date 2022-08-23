part of 'settings_bloc.dart';

class SettingsState extends Equatable {
  final BlocStatus status;

  const SettingsState({
    required this.status,
  });

  @override
  List<Object> get props => [status];

  SettingsState copyWith({
    BlocStatus? status,
  }) {
    return SettingsState(
      status: status ?? const BlocStatusInProgress(),
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
  userHasBeenSignedOut,
  userAccountHasBeenDeleted,
}

enum SettingsBlocError {
  wrongPassword,
}
