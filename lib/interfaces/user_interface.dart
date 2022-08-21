import '../models/avatar.dart';

abstract class UserInterface {
  Future<void> setUserData({
    required String username,
    required Avatar avatar,
  });
}
