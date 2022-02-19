import 'dart:io';
import 'package:app/interfaces/avatar_interface.dart';
import 'package:app/models/avatar_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AvatarService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> saveAvatarInDb({
    required AvatarType type,
    String? avatarImgFilePath,
  }) async {
    if (type == AvatarType.custom && avatarImgFilePath != null) {
      return await _uploadAvatarToDb(avatarImgFilePath);
    } else {
      return _getPathToStandardAvatarInDb(type);
    }
  }

  AvatarType? getAvatarType(AvatarInterface avatar) {
    if (avatar is StandardAvatarRed) {
      return AvatarType.red;
    } else if (avatar is StandardAvatarGreen) {
      return AvatarType.green;
    } else if (avatar is StandardAvatarBlue) {
      return AvatarType.blue;
    } else if (avatar is CustomAvatar) {
      return AvatarType.custom;
    }
  }

  String? getImgFilePath(AvatarInterface avatar) {
    if (avatar is CustomAvatarInterface) {
      return avatar.imgFilePathFromDevice;
    }
  }

  Future<String> _uploadAvatarToDb(String filePathFromDevice) async {
    String? filePathInDb = _createPathToAvatarInDb(filePathFromDevice);
    if (filePathInDb != null) {
      File file = File(filePathFromDevice);
      await _uploadFileToStorage(filePathInDb, file);
      return filePathInDb;
    } else {
      throw 'Cannot generate path for custom avatar';
    }
  }

  String? _createPathToAvatarInDb(String filePath) {
    final User? user = _firebaseAuth.currentUser;
    if (user != null) {
      List<String> filePathParties = filePath.split('/');
      return '${user.uid}/${filePathParties[filePathParties.length - 1]}';
    }
  }

  String _getPathToStandardAvatarInDb(AvatarType type) {
    if (type == AvatarType.red) {
      return 'avatars/RedBook.png';
    } else if (type == AvatarType.green) {
      return 'avatars/GreenBook.png';
    } else if (type == AvatarType.blue) {
      return 'avatars/BlueBook.png';
    } else {
      throw 'Cannot get path for the type of avatar: $type';
    }
  }

  _uploadFileToStorage(String filePath, File file) async {
    await _storage.ref().child(filePath).putFile(file);
  }
}

enum AvatarType {
  red,
  green,
  blue,
  custom,
}
