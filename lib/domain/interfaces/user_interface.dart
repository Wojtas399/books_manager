import 'package:app/domain/entities/user.dart';

abstract class UserInterface {
  Stream<User?> getUser({required String userId});

  Future<void> addUser({required User user});

  Future<void> updateUser({
    required String userId,
    bool? isDarkModeOn,
    bool? isDarkModeCompatibilityWithSystemOn,
  });

  Future<void> deleteUser({required String userId});
}
