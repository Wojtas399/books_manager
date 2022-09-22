import 'package:equatable/equatable.dart';

class DbUser extends Equatable {
  final String id;
  final bool isDarkModeOn;
  final bool isDarkModeCompatibilityWithSystemOn;

  const DbUser({
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
}

DbUser createDbUser({
  String id = '',
  bool isDarkModeOn = false,
  bool isDarkModeCompatibilityWithSystemOn = false,
}) {
  return DbUser(
    id: id,
    isDarkModeOn: isDarkModeOn,
    isDarkModeCompatibilityWithSystemOn: isDarkModeCompatibilityWithSystemOn,
  );
}
