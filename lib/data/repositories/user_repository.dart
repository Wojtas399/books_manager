import 'dart:async';

import 'package:app/data/data_sources/user_data_source.dart';
import 'package:app/domain/entities/user.dart';
import 'package:app/domain/interfaces/user_interface.dart';

class UserRepository implements UserInterface {
  late final UserDataSource _userDataSource;

  UserRepository({
    required UserDataSource userDataSource,
  }) {
    _userDataSource = userDataSource;
  }

  @override
  Stream<User?> getUser({required String userId}) {
    return _userDataSource.getUser(userId: userId);
  }

  @override
  Future<void> addUser({required User user}) async {
    await _userDataSource.addUser(user: user);
  }

  @override
  Future<void> updateUser({
    required String userId,
    bool? isDarkModeOn,
    bool? isDarkModeCompatibilityWithSystemOn,
  }) async {
    await _userDataSource.updateUser(
      userId: userId,
      isDarkModeOn: isDarkModeOn,
      isDarkModeCompatibilityWithSystemOn: isDarkModeCompatibilityWithSystemOn,
    );
  }

  @override
  Future<void> deleteUser({required String userId}) async {
    await _userDataSource.deleteUser(userId: userId);
  }
}
