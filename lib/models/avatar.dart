import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class Avatar extends Equatable {}

class UrlAvatar extends Avatar {
  final String url;

  UrlAvatar({required this.url});

  @override
  List<Object> get props => [url];
}

class FileAvatar extends Avatar {
  final File file;

  FileAvatar({required this.file});

  @override
  List<Object> get props => [file];
}

class BasicAvatar extends Avatar {
  final BasicAvatarType type;

  BasicAvatar({required this.type});

  @override
  List<Object> get props => [type];
}

enum BasicAvatarType { red, green, blue }

extension BasicAvatarTypeExtensions on BasicAvatarType {
  String toAssetsPath() {
    switch (this) {
      case BasicAvatarType.red:
        return 'assets/images/RedBook.png';
      case BasicAvatarType.green:
        return 'assets/images/GreenBook.png';
      case BasicAvatarType.blue:
        return 'assets/images/BlueBook.png';
    }
  }
}
