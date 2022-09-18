import 'package:app/data/data_sources/local_db/sqlite/sqlite_sync_state.dart';
import 'package:equatable/equatable.dart';

class SqliteUser extends Equatable {
  final String id;
  final bool isDarkModeOn;
  final bool isDarkModeCompatibilityWithSystemOn;
  final SyncState syncState;

  const SqliteUser({
    required this.id,
    required this.isDarkModeOn,
    required this.isDarkModeCompatibilityWithSystemOn,
    required this.syncState,
  });

  SqliteUser.fromJson(Map<String, Object?> json)
      : this(
          id: json[SqliteUserFields.id] as String,
          isDarkModeOn: (json[SqliteUserFields.isDarkModeOn] as int) == 1,
          isDarkModeCompatibilityWithSystemOn:
              (json[SqliteUserFields.isDarkModeCompatibilityWithSystemOn]
                      as int) ==
                  1,
          syncState: (json[SqliteUserFields.syncState] as String).toSyncState(),
        );

  @override
  List<Object> get props => [
        id,
        isDarkModeOn,
        isDarkModeCompatibilityWithSystemOn,
        syncState,
      ];

  Map<String, Object?> toJson() => {
        SqliteUserFields.id: id,
        SqliteUserFields.isDarkModeOn: isDarkModeOn ? 1 : 0,
        SqliteUserFields.isDarkModeCompatibilityWithSystemOn:
            isDarkModeCompatibilityWithSystemOn ? 1 : 0,
        SqliteUserFields.syncState: syncState.name,
      };

  SqliteUser copyWith({
    bool? isDarkModeOn,
    bool? isDarkModeCompatibilityWithSystemOn,
    SyncState? syncState,
  }) {
    return SqliteUser(
      id: id,
      isDarkModeOn: isDarkModeOn ?? this.isDarkModeOn,
      isDarkModeCompatibilityWithSystemOn:
          isDarkModeCompatibilityWithSystemOn ??
              this.isDarkModeCompatibilityWithSystemOn,
      syncState: syncState ?? this.syncState,
    );
  }
}

class SqliteUserFields {
  static const String id = 'id';
  static const String isDarkModeOn = 'isDarkModeOn';
  static const String isDarkModeCompatibilityWithSystemOn =
      'isDarkModeCompatibilityWithSystemOn';
  static const String syncState = 'syncState';
}
