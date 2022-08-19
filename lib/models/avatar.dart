import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class Avatar extends Equatable {
  const Avatar();
}

class UrlAvatar extends Avatar {
  final String url;

  const UrlAvatar({required this.url});

  @override
  List<Object> get props => [url];
}

class FileAvatar extends Avatar {
  final File file;

  const FileAvatar({required this.file});

  @override
  List<Object> get props => [file];
}

class BasicAvatar extends Avatar {
  final BasicAvatarType type;

  const BasicAvatar({required this.type});

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
