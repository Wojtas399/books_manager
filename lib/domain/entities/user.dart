import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final bool isDarkModeOn;
  final bool isDarkModeCompatibilityWithSystemOn;

  const User({
    required this.id,
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
