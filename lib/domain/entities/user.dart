import 'package:app/models/entity.dart';

class User extends Entity {
  final bool isDarkModeOn;
  final bool isDarkModeCompatibilityWithSystemOn;

  const User({
    required super.id,
    required this.isDarkModeOn,
    required this.isDarkModeCompatibilityWithSystemOn,
  });

  @override
  List<Object> get props => [
        id,
        isDarkModeOn,
        isDarkModeCompatibilityWithSystemOn,
      ];

  User copyWith({
    bool? isDarkModeOn,
    bool? isDarkModeCompatibilityWithSystemOn,
  }) {
    return User(
      id: id,
      isDarkModeOn: isDarkModeOn ?? this.isDarkModeOn,
      isDarkModeCompatibilityWithSystemOn:
          isDarkModeCompatibilityWithSystemOn ??
              this.isDarkModeCompatibilityWithSystemOn,
    );
  }
}

User createUser({
  String id = '',
  bool isDarkModeOn = false,
  bool isDarkModeCompatibilityWithSystemOn = false,
}) {
  return User(
    id: id,
    isDarkModeOn: isDarkModeOn,
    isDarkModeCompatibilityWithSystemOn: isDarkModeCompatibilityWithSystemOn,
  );
}
