import 'package:equatable/equatable.dart';

class FirebaseUser extends Equatable {
  final String id;
  final bool isDarkModeOn;
  final bool isDarkModeCompatibilityWithSystemOn;

  const FirebaseUser({
    required this.id,
    required this.isDarkModeOn,
    required this.isDarkModeCompatibilityWithSystemOn,
  });

  FirebaseUser.fromJson({
    required String userId,
    required Map<String, Object?> json,
  }) : this(
          id: userId,
          isDarkModeOn: json[FirebaseUserFields.isDarkModeOn] as bool,
          isDarkModeCompatibilityWithSystemOn:
              json[FirebaseUserFields.isDarkModeCompatibilityWithSystemOn]
                  as bool,
        );

  @override
  List<Object> get props => [
        id,
        isDarkModeOn,
        isDarkModeCompatibilityWithSystemOn,
      ];

  Map<String, Object?> toJson() => {
        FirebaseUserFields.isDarkModeOn: isDarkModeOn,
        FirebaseUserFields.isDarkModeCompatibilityWithSystemOn:
            isDarkModeCompatibilityWithSystemOn,
      };

  FirebaseUser copyWith({
    bool? isDarkModeOn,
    bool? isDarkModeCompatibilityWithSystemOn,
  }) {
    return FirebaseUser(
      id: id,
      isDarkModeOn: isDarkModeOn ?? this.isDarkModeOn,
      isDarkModeCompatibilityWithSystemOn:
          isDarkModeCompatibilityWithSystemOn ??
              this.isDarkModeCompatibilityWithSystemOn,
    );
  }
}

class FirebaseUserFields {
  static const String isDarkModeOn = 'isDarkModeOn';
  static const String isDarkModeCompatibilityWithSystemOn =
      'isDarkModeCompatibilityWithSystemOn';
}

FirebaseUser createFirebaseUser({
  String id = '',
  bool isDarkModeOn = false,
  bool isDarkModeCompatibilityWithSystemOn = false,
}) {
  return FirebaseUser(
    id: id,
    isDarkModeOn: isDarkModeOn,
    isDarkModeCompatibilityWithSystemOn: isDarkModeCompatibilityWithSystemOn,
  );
}
