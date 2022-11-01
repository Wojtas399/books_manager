import 'package:app/data/data_sources/firebase/entities/firebase_day.dart';
import 'package:equatable/equatable.dart';

class FirebaseUser extends Equatable {
  final String id;
  final bool isDarkModeOn;
  final bool isDarkModeCompatibilityWithSystemOn;
  final List<FirebaseDay> daysOfReading;

  const FirebaseUser({
    required this.id,
    required this.isDarkModeOn,
    required this.isDarkModeCompatibilityWithSystemOn,
    required this.daysOfReading,
  });

  FirebaseUser.fromJson({
    required Map<String, Object?> json,
    required String userId,
  }) : this(
          id: userId,
          isDarkModeOn: json[FirebaseUserFields.isDarkModeOn] as bool,
          isDarkModeCompatibilityWithSystemOn:
              json[FirebaseUserFields.isDarkModeCompatibilityWithSystemOn]
                  as bool,
          daysOfReading: (json[FirebaseUserFields.daysOfReading] as List)
              .map(
                (dayJson) => FirebaseDay.fromJson(
                  json: dayJson,
                  userId: userId,
                ),
              )
              .toList(),
        );

  @override
  List<Object> get props => [
        id,
        isDarkModeOn,
        isDarkModeCompatibilityWithSystemOn,
        daysOfReading,
      ];

  Map<String, Object?> toJson() => {
        FirebaseUserFields.isDarkModeOn: isDarkModeOn,
        FirebaseUserFields.isDarkModeCompatibilityWithSystemOn:
            isDarkModeCompatibilityWithSystemOn,
        FirebaseUserFields.daysOfReading:
            daysOfReading.map((FirebaseDay day) => day.toJson()).toList(),
      };

  FirebaseUser copyWith({
    bool? isDarkModeOn,
    bool? isDarkModeCompatibilityWithSystemOn,
    List<FirebaseDay>? daysOfReading,
  }) {
    return FirebaseUser(
      id: id,
      isDarkModeOn: isDarkModeOn ?? this.isDarkModeOn,
      isDarkModeCompatibilityWithSystemOn:
          isDarkModeCompatibilityWithSystemOn ??
              this.isDarkModeCompatibilityWithSystemOn,
      daysOfReading: daysOfReading ?? this.daysOfReading,
    );
  }
}

class FirebaseUserFields {
  static const String isDarkModeOn = 'isDarkModeOn';
  static const String isDarkModeCompatibilityWithSystemOn =
      'isDarkModeCompatibilityWithSystemOn';
  static const String daysOfReading = 'daysOfReading';
}

FirebaseUser createFirebaseUser({
  String id = '',
  bool isDarkModeOn = false,
  bool isDarkModeCompatibilityWithSystemOn = false,
  List<FirebaseDay> daysOfReading = const [],
}) {
  return FirebaseUser(
    id: id,
    isDarkModeOn: isDarkModeOn,
    isDarkModeCompatibilityWithSystemOn: isDarkModeCompatibilityWithSystemOn,
    daysOfReading: daysOfReading,
  );
}
