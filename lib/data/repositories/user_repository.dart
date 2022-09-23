import 'package:app/data/data_sources/local_db/sqlite/sqlite_sync_state.dart';
import 'package:app/data/data_sources/local_db/user_local_db_service.dart';
import 'package:app/data/data_sources/remote_db/user_remote_db_service.dart';
import 'package:app/data/mappers/user_mapper.dart';
import 'package:app/data/models/db_user.dart';
import 'package:app/data/synchronizers/user_synchronizer.dart';
import 'package:app/domain/entities/user.dart';
import 'package:app/domain/interfaces/user_interface.dart';
import 'package:app/extensions/list_extensions.dart';
import 'package:app/models/device.dart';
import 'package:rxdart/rxdart.dart';

class UserRepository implements UserInterface {
  late final UserSynchronizer _userSynchronizer;
  late final UserLocalDbService _userLocalDbService;
  late final UserRemoteDbService _userRemoteDbService;
  late final Device _device;
  final BehaviorSubject<List<User>> _users$ = BehaviorSubject<List<User>>();

  UserRepository({
    required UserSynchronizer userSynchronizer,
    required UserLocalDbService userLocalDbService,
    required UserRemoteDbService userRemoteDbService,
    required Device device,
    List<User> users = const [],
  }) {
    _userSynchronizer = userSynchronizer;
    _userLocalDbService = userLocalDbService;
    _userRemoteDbService = userRemoteDbService;
    _device = device;
    _users$.add(users);
  }

  Stream<List<User>> get _usersStream$ => _users$.stream;

  @override
  Future<void> refreshUser({required String userId}) async {
    if (await _device.hasInternetConnection()) {
      await _userSynchronizer.synchronizeUser(userId: userId);
    }
  }

  @override
  Stream<User?> getUser({required String userId}) {
    return _usersStream$.map(
      (List<User> users) {
        final List<User?> allUsers = [...users];
        return allUsers.firstWhere(
          (User? user) => user?.id == userId,
          orElse: () => null,
        );
      },
    );
  }

  @override
  Future<void> loadUser({required String userId}) async {
    final DbUser dbUser = await _userLocalDbService.loadUser(userId: userId);
    final User user = UserMapper.mapFromDbModelToEntity(dbUser);
    _addUserToList(user);
  }

  @override
  Future<void> addUser({required User user}) async {
    final DbUser dbUser = UserMapper.mapFromEntityToDbModel(user);
    SyncState syncState = SyncState.added;
    if (await _device.hasInternetConnection()) {
      await _userRemoteDbService.addUser(dbUser: dbUser);
      syncState = SyncState.none;
    }
    await _userLocalDbService.addUser(dbUser: dbUser, syncState: syncState);
    _addUserToList(user);
  }

  @override
  Future<void> addReadPagesForUser({
    required String userId,
    required String bookId,
    required int readPagesAmount,
  }) async {
    throw UnimplementedError();
    //TODO: implement method
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
    _updateUserInList(updatedUser);
    try {
      await _tryUpdateUserThemeSettings(
        userId,
        isDarkModeOn,
        isDarkModeCompatibilityWithSystemOn,
      );
    } catch (_) {
      _updateUserInList(originalUser);
    }
  }

  @override
  Future<void> deleteUser({required String userId}) async {
    if (await _device.hasInternetConnection()) {
      await _userRemoteDbService.deleteUser(userId: userId);
      await _userLocalDbService.deleteUser(userId: userId);
    } else {
      await _userLocalDbService.updateUser(
        userId: userId,
        syncState: SyncState.deleted,
      );
    }
    _deleteUserFromList(userId);
  }

  Future<void> _tryUpdateUserThemeSettings(
    String userId,
    bool? isDarkModeOn,
    bool? isDarkModeCompatibilityWithSystemOn,
  ) async {
    SyncState? syncState = SyncState.updated;
    if (await _device.hasInternetConnection()) {
      await _userRemoteDbService.updateUser(
        userId: userId,
        isDarkModeOn: isDarkModeOn,
        isDarkModeCompatibilityWithSystemOn:
            isDarkModeCompatibilityWithSystemOn,
      );
      syncState = SyncState.none;
    }
    await _userLocalDbService.updateUser(
      userId: userId,
      isDarkModeOn: isDarkModeOn,
      isDarkModeCompatibilityWithSystemOn: isDarkModeCompatibilityWithSystemOn,
      syncState: syncState,
    );
  }

  void _addUserToList(User user) {
    final List<User> users = [..._users$.value];
    users.add(user);
    _users$.add(
      users.removeRepetitions(),
    );
  }

  void _updateUserInList(User updatedUser) {
    final List<User> users = [..._users$.value];
    final int index = users.indexWhere(
      (User user) => user.id == updatedUser.id,
    );
    users[index] = updatedUser;
    _users$.add(
      users.removeRepetitions(),
    );
  }

  void _deleteUserFromList(String userId) {
    final List<User> users = [..._users$.value];
    users.removeWhere((User user) => user.id == userId);
    _users$.add(
      users.removeRepetitions(),
    );
  }
}
