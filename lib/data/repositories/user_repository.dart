import 'package:app/domain/entities/user.dart';
import 'package:app/domain/interfaces/user_interface.dart';

class UserRepository implements UserInterface {
  @override
  Future<void> refreshUser({required String userId}) {
    // TODO: implement refreshUser
    throw UnimplementedError();
  }

  @override
  Stream<User> getUser({required String userId}) {
    // TODO: implement getUser
    throw UnimplementedError();
  }

  @override
  Future<void> loadUser({required String userId}) {
    // TODO: implement loadUser
    throw UnimplementedError();
  }

  @override
  Future<void> addUser({required User user}) {
    // TODO: implement addUser
    throw UnimplementedError();
  }

  @override
  Future<void> updateUser({
    required String userId,
    bool? isDarkModeOn,
    bool? isDarkModeCompatibilityWithSystemOn,
  }) {
    // TODO: implement updateUser
    throw UnimplementedError();
  }

  @override
  Future<void> deleteUser({required String userId}) {
    // TODO: implement deleteUser
    throw UnimplementedError();
  }

  @override
  void reset() {
    // TODO: implement reset
  }
}
