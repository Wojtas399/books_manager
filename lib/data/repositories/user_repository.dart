import 'dart:async';

import 'package:app/data/data_sources/users_data_source.dart';
import 'package:app/domain/entities/user.dart';
import 'package:app/domain/interfaces/user_interface.dart';
import 'package:app/models/repository.dart';

class UserRepository extends Repository<User> implements UserInterface {
  late final UsersDataSource _usersDataSource;
  StreamSubscription<User?>? _userListener;

  UserRepository({
    required UsersDataSource usersDataSource,
    List<User>? users,
  }) {
    _usersDataSource = usersDataSource;

    if (users != null) {
      addEntities(users);
    }
  }

  @override
  void reset() {
    _resetUserListener();
    super.reset();
  }

  @override
  Stream<User?> getUser({required String userId}) {
    return stream.map(
      (List<User>? users) {
        final List<User?> allUsers = [...?users];
        return allUsers.firstWhere(
          (User? user) => user?.id == userId,
          orElse: () => null,
        );
      },
    );
  }

  @override
  Future<void> loadUser({required String userId}) async {
    _resetUserListener();
    _userListener ??= _usersDataSource
        .getUserStream(userId: userId)
        .listen((User? user) => _manageUser(userId, user));
  }

  @override
  Future<void> addUser({required User user}) async {
    await _usersDataSource.addUser(user: user);
    addEntity(user);
  }

  @override
  Future<void> updateUserThemeSettings({
    required String userId,
    bool? isDarkModeOn,
    bool? isDarkModeCompatibilityWithSystemOn,
  }) async {
    final User? originalUser = await getUser(userId: userId).first;
    if (originalUser == null) {
      return;
    }
    final User updatedUser = originalUser.copyWith(
      isDarkModeOn: isDarkModeOn,
      isDarkModeCompatibilityWithSystemOn: isDarkModeCompatibilityWithSystemOn,
    );
    updateEntity(updatedUser);
    try {
      await _usersDataSource.updateUser(
        userId: userId,
        isDarkModeOn: isDarkModeOn,
        isDarkModeCompatibilityWithSystemOn:
            isDarkModeCompatibilityWithSystemOn,
      );
    } catch (error) {
      updateEntity(originalUser);
    }
  }

  @override
  Future<void> deleteUser({required String userId}) async {
    await _usersDataSource.deleteUser(userId: userId);
    removeEntity(userId);
  }

  void _resetUserListener() {
    _userListener?.cancel();
    _userListener = null;
  }

  void _manageUser(String userId, User? user) {
    if (user == null) {
      removeEntity(userId);
    } else {
      final List<String> existingUsersIds =
          <User>[...?value].map((User user) => user.id).toList();
      if (existingUsersIds.contains(userId)) {
        updateEntity(user);
      } else {
        addEntity(user);
      }
    }
  }
}
