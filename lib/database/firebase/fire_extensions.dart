import '../../models/avatar.dart';

extension FireBasicAvatarTypeExtensions on BasicAvatarType {
  String toFirebaseString() {
    switch (this) {
      case BasicAvatarType.red:
        return 'RedBook';
      case BasicAvatarType.green:
        return 'GreenBook';
      case BasicAvatarType.blue:
        return 'BlueBook';
    }
  }
}