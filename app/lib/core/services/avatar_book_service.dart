import 'package:app/common/enum/avatar_type.dart';

class AvatarBookService {
  String getBookFileName(AvatarType avatarType) {
    switch (avatarType) {
      case AvatarType.red:
        {
          return 'RedBook.png';
        }
      case AvatarType.green:
        {
          return 'GreenBook.png';
        }
      case AvatarType.blue:
        {
          return 'BlueBook.png';
        }
      case AvatarType.custom:
        {
          return '';
        }
    }
  }

  AvatarType getBookType(String fileName) {
    switch (fileName) {
      case 'RedBook.png':
        {
          return AvatarType.red;
        }
      case 'GreenBook.png':
        {
          return AvatarType.green;
        }
      case 'BlueBook.png':
        {
          return AvatarType.blue;
        }
      default:
        {
          return AvatarType.custom;
        }
    }
  }
}