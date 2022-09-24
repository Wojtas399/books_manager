import 'package:app/domain/entities/user.dart';

abstract class UserInterface {
  Future<void> refreshUser({required String userId});

  Stream<User?> getUser({required String userId});

  Future<void> loadUser({required String userId});

  Future<void> addUser({required User user});

  Future<void> updateUserThemeSettings({
    required String userId,
    bool? isDarkModeOn,
    bool? isDarkModeCompatibilityWithSystemOn,
  });

  Future<void> deleteUser({required String userId});
}
